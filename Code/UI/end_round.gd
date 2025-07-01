class_name EndRoundUi extends RidControl


@onready var round_label: Label = %round_label
@onready var btn_return: Button = %btn_return
@onready var btn_continue: Button = %btn_continue


func _ready() -> void:
	btn_continue.pressed.connect(_continue_pressed)
	btn_return.pressed.connect(_main_menu_pressed)


func toggle_display(value := false) -> void:
	if value:
		round_label.text = "Round %s Complete" % Data.run_data.current_round
		show()
	else:
		hide()


func _main_menu_pressed() -> void:
	pass


func _continue_pressed() -> void:
	Signals.ToggleDisplay.emit(&"player_ui", &"end_round", true)
	Signals.UpdateTimer.emit()
	Signals.StartNextRound.emit()
