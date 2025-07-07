class_name MainMenu extends RidControl


@onready var btn_play: Button = %btn_play


func _ready() -> void:
	Signals.start_manager.emit(&"game_manager")
	btn_play.pressed.connect(_btn_play)


func _btn_play() -> void:
	Signals.InitNewRun.emit()
	Signals.LoadLevel.emit(&"test_level")
