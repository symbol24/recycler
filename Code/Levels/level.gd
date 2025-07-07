class_name Level extends Node2D


func _ready() -> void:
	Signals.character_ready.connect(_start)
	Signals.start_manager.emit(&"spawn_manager")
	Signals.toggle_display.emit(&"player_ui", &"", true)
	Signals.update_timer.emit()
	Signals.spawn_character.emit()


func _start(_character) -> void:
	Signals.show_start_timer.emit()


func _exit_tree() -> void:
	Signals.kill_manager.emit(&"spawn_manager")
