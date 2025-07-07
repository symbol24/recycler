class_name MainMenu extends RidControl


@onready var btn_play: Button = %btn_play


func _ready() -> void:
	Signals.start_manager.emit(&"game_manager")
	btn_play.pressed.connect(_btn_play)


func _btn_play() -> void:
	Signals.init_new_run.emit()
	Signals.load_level.emit(&"test_level")
