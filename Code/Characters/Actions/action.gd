class_name CharacterAction extends Node2D


var parent:Character


func _ready() -> void:
	parent = get_parent() as Character
	assert(parent != null, "Parent is missing for %s." % name)
