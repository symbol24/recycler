class_name Level extends Node2D


func _ready() -> void:
	Signals.CharacterReady.connect(_start)
	Signals.StartManager.emit(&"spawn_manager")
	Signals.ToggleDisplay.emit(&"player_ui", &"", true)
	Signals.UpdateTimer.emit()
	Signals.SpawnCharacter.emit()


func _start(_character) -> void:
	Signals.ShowStartTimer.emit()


func _exit_tree() -> void:
	Signals.KillManager.emit(&"spawn_manager")
