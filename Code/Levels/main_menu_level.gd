class_name MainMenuLevel extends Node2D


func _ready() -> void:
	Signals.toggle_display.emit(&"main_menu")
