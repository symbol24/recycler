class_name Boot extends Node2D


func _ready() -> void:
	await get_tree().create_timer(2).timeout
	Signals.load_level.emit(&"main_menu")
	queue_free()
