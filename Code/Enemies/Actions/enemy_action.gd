class_name EnemyAction extends Node2D


var parent:Enemy


func _ready() -> void:
	parent = get_parent() as Enemy
	assert(parent != null, "Parent is missing for %s." % name)
