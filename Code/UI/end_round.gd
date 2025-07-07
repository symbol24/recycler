class_name EndRoundUi extends RidControl


@onready var round_label: Label = %round_label
@onready var btn_return: Button = %btn_return
@onready var btn_continue: Button = %btn_continue


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	btn_continue.pressed.connect(_continue_pressed)
	btn_return.pressed.connect(_main_menu_pressed)
	Signals.return_pupup_result.connect(_popup_result)


func toggle_display(value := false) -> void:
	if value:
		if Data.run_data.current_round >= Data.run_data.max_round_count:
			round_label.text = "Run Complete! Final Boss defeated!"
			btn_continue.hide()
		else:
			round_label.text = "Round %s Complete" % Data.run_data.current_round
			btn_continue.show()
		show()
	else:
		hide()


func _main_menu_pressed() -> void:
	if Data.run_data.current_round >= Data.run_data.max_round_count:
		Signals.load_level.emit(&"main_menu", true)
	else:
		Signals.display_popup.emit(&"end_round_main_menu", true, "Return to Main Menu?", "Unsaved progression will be lost.", true)


func _popup_result(popup_id:StringName, result := false) -> void:
	if popup_id == &"end_round_main_menu" and result:
		Signals.load_level.emit(&"main_menu", true)


func _continue_pressed() -> void:
	Signals.toggle_display.emit(&"player_ui", &"end_round", true)
	Signals.update_timer.emit()
	Signals.start_next_round.emit()
