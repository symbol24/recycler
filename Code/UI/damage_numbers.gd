class_name DamageNumbers extends Control


const DMGNBR := "uid://c0y7ohqly322e"
const YOFFSET := 24.0


var dmgnbr:PackedScene = null:
	get:
		if dmgnbr == null: dmgnbr = load(DMGNBR)
		return dmgnbr
var pool:Array[DamageNumber] = []


func _ready() -> void:
	Signals.RemoveDamageNumber.connect(_return_to_pool)
	Signals.SpawnDamageNumber.connect(_spawn_dmg_nbr)


func _spawn_dmg_nbr(value:int, location:Vector2, type:Damage.Type) -> void:
	var new:DamageNumber = _get_dmg_nbr()
	add_child(new)
	if not new.is_node_ready(): await new.ready
	new.text = str(value)
	var pos:Vector2 = Vector2(location.x - (new.size.x/2), location.y - YOFFSET)
	new.global_position = pos
	match type:
		Damage.Type.FIRE:
			new.modulate = Color.DARK_ORANGE
		Damage.Type.POISON:
			new.modulate = Color.WEB_PURPLE
		Damage.Type.HEAL:
			new.modulate = Color.WEB_GREEN
		_:
			new.modulate = Color.DARK_RED
	new.display()


func _get_dmg_nbr() -> DamageNumber:
	if pool.is_empty():
		return dmgnbr.instantiate()
	else:
		return pool.pop_front()


func _return_to_pool(_dmgnbr:Label) -> void:
	if is_instance_valid(_dmgnbr):
		remove_child(_dmgnbr)
		pool.append(_dmgnbr)
