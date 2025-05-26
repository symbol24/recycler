class_name Level extends Node2D


func _ready() -> void:
	Signals.ToggleDisplay.emit(&"player_ui", &"", true)
