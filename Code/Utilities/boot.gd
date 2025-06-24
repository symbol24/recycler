class_name Boot extends Node2D


func _ready() -> void:
	await get_tree().create_timer(2).timeout
	Signals.LoadLevel.emit(&"main_menu")
	queue_free()
