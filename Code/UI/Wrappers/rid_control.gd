class_name RidControl extends Control


@export var id := &""


func toggle_display(value := false) -> void:
	if value:
		show()
	else:
		hide()
