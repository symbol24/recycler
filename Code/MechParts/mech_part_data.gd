class_name MechPartData extends Resource


@export var id := &""
@export var drop_uid := ""
@export var attachment_uid := ""
@export var stats:Dictionary = {&"variable_name": 0.0}
@export var level := 1


func get_stat(variable:StringName) -> Variant:
	if stats.has(variable): return stats[variable]
	return 0
