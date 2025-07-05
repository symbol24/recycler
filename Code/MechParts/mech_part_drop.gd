class_name MechPartDrop extends Sprite2D


const STARTANIMTIME := 0.5


@onready var collect_collider: CollisionShape2D = $collect_area/collect_collider

var mech_part_data:MechPartData
var start_pos := Vector2.ZERO
var target_pos := Vector2.ZERO
var height_diff := 0.0

var _can_be_picked_up := false


func setup_mech_part_drop(data:MechPartData, _start_pos:Vector2, _target_pos:Vector2) -> void:
	if data == null: return

	start_pos = _start_pos
	global_position = start_pos
	target_pos = _target_pos
	height_diff = start_pos.y - target_pos.y
	mech_part_data = data.duplicate(true)
	_can_be_picked_up = false

	if mech_part_data.drop_uid != "":
		texture = load(mech_part_data.drop_uid) as CompressedTexture2D


func play_drop() -> void:
	var tween := create_tween()
	tween.set_parallel(false)
	tween.tween_property(self, "global_position", target_pos, STARTANIMTIME)
	tween.tween_property(self, "global_position", Vector2(start_pos.x, start_pos.y - (height_diff/2)), STARTANIMTIME/2)
	tween.tween_property(self, "global_position", target_pos, STARTANIMTIME/2)
	tween.tween_property(self, "global_position", Vector2(start_pos.x, start_pos.y - (height_diff/3)), STARTANIMTIME/3)
	tween.tween_property(self, "global_position", target_pos, STARTANIMTIME/3)
	tween.tween_property(self, "global_position", Vector2(start_pos.x, start_pos.y - (height_diff/4)), STARTANIMTIME/4)
	tween.tween_property(self, "global_position", target_pos, STARTANIMTIME/4)

	await tween.finished
	_can_be_picked_up = true
