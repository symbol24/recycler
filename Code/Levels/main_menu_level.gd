class_name MainMenuLevel extends Node2D


func _ready() -> void:
	Signals.ToggleDisplay.emit(&"main_menu")
