class_name MechPartDrop extends Area2D


const STARTANIMTIME := 0.15
const PARTVERTOFFSET := 5.0


var mech_part_data:MechPartData

var _start_pos := Vector2.ZERO
var _target_pos := Vector2.ZERO
var _height_diff := 0.0

@onready var collect_collider: CollisionShape2D = %collect_collider
@onready var sprite: Sprite2D = %sprite


func setup_mech_part_drop(data:MechPartData, _pos:Vector2, _t_pos:Vector2) -> void:
	collect_collider.set_deferred(&"disabled", true)

	if data == null: return

	_start_pos = _pos
	global_position = _start_pos
	_target_pos = _t_pos
	_height_diff = _start_pos.y - _target_pos.y
	mech_part_data = data.duplicate(true)

	if mech_part_data.drop_uid != "":
		sprite.texture = load(mech_part_data.drop_uid) as CompressedTexture2D


func play_drop() -> void:
	var tween := create_tween()
	tween.set_parallel(false)
	tween.tween_property(self, "global_position", Vector2(_start_pos.x, _start_pos.y - PARTVERTOFFSET), STARTANIMTIME)
	tween.tween_property(self, "global_position", _start_pos, STARTANIMTIME)
	tween.tween_property(self, "global_position", Vector2(_start_pos.x, _start_pos.y - PARTVERTOFFSET/2), STARTANIMTIME/2)
	tween.tween_property(self, "global_position", _start_pos, STARTANIMTIME/2)
	tween.tween_property(self, "global_position", Vector2(_start_pos.x, _start_pos.y - PARTVERTOFFSET/3), STARTANIMTIME/3)
	tween.tween_property(self, "global_position", _start_pos, STARTANIMTIME/3)

	await tween.finished
	collect_collider.set_deferred(&"disabled", false)


func get_part() -> MechPartData:
	get_tree().create_timer(0.1).timeout.connect(_return_part)
	return mech_part_data


func _return_part() -> void:
	Signals.return_mech_part_drop.emit(self)
