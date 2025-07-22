class_name PickupArea extends Area2D


var parent:Character


func _ready() -> void:
	parent = get_parent() as Character
	assert(parent != null, "Parent is missing for %s." % name)
	area_entered.connect(_area_entered)
	

func _area_entered(area:Area2D) -> void:
	if area.has_method(&"get_part"):
		parent.data.pickup_merch_part_data(area.get_part())
