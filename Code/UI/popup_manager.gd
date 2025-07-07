class_name PopupManager extends Control


const SMALLTIMER := 3
const LARGETIMER := 15


@onready var popup_timer: Timer = %popup_timer
@onready var large_popup: PanelContainer = %large_popup
@onready var large_title: Label = %large_title
@onready var large_text: Label = %large_text
@onready var timer_label: Label = %timer
@onready var btn_popup_cancel: Button = %btn_popup_cancel
@onready var btn_popup_confirm: Button = %btn_popup_confirm
@onready var small_popup: PanelContainer = %small_popup
@onready var small_popup_text: Label = %small_popup_text

var current_popup := &""
var max_time := 0
var result := false


func _ready() -> void:
	Signals.display_popup.connect(_display_popup)
	popup_timer.timeout.connect(_timer_timeout)
	btn_popup_cancel.pressed.connect(_close_popup)
	btn_popup_confirm.pressed.connect(_confirm_pressed)


func _display_popup(id:StringName, is_large := false, title := "", text := "", timed := true) -> void:
	UI.move_child(UI.popup_manager, UI.get_child_count()-1)
	current_popup = id
	result = false
	
	if is_large:
		large_title.text = title
		large_text.text = text
		if timed:
			max_time = LARGETIMER
			timer_label.text = str(max_time)
			popup_timer.start()
		else:
			max_time = 0
		large_popup.show()
	else:
		small_popup_text.text = text
		max_time = SMALLTIMER
		small_popup.show()
		popup_timer.start()

	show()


func _confirm_pressed() -> void:
	result = true
	_close_popup()


func _close_popup() -> void:
	large_popup.hide()
	small_popup.hide()
	if not popup_timer.is_stopped(): 
		popup_timer.stop()
		popup_timer.wait_time = 1.0
	hide()
	Signals.return_pupup_result.emit(current_popup, result)


func _timer_timeout() -> void:
	if max_time > 0:
		max_time -= 1
		timer_label.text = str(max_time)
		popup_timer.start()
	else:
		_close_popup()
