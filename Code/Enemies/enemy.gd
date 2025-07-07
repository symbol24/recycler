class_name Enemy extends CharacterBody2D


enum {DEAD, SPAWNING, IDLE, MOVING}


@export var debug_data:EnemyData
@export var debug_spawn := false

var data:EnemyData
var state := SPAWNING
var body_x := 0.0
var player:Character = null:
	get:
		if player == null: player = get_tree().get_first_node_in_group(&"player")
		return player

@onready var body: AnimatedSprite2D = %body
@onready var hp_bar: TextureProgressBar = %hp_bar


func _ready() -> void:
	body.animation_finished.connect(_body_animation_finished)
	body_x = body.position.x
	if debug_spawn: setup_character()


func _process(_delta: float) -> void:
	if state in [IDLE, MOVING]:
		if state == IDLE and velocity.length_squared() > 0.0: state = MOVING
		elif state == MOVING and velocity.length() == 0.0: state = IDLE
		_update_body_animation(state)
		_flip_body()
		move_and_slide()


func setup_character(new_data := debug_data) -> void:
	assert(new_data != null, "Data is missing from %s." % name)
	data = new_data.duplicate()
	data.setup_data()
	state = IDLE
	hp_bar.value = float(data.current_hp) / float(data.max_hp)


func receive_damage(damage:Damage) -> void:
	if damage:
		var value:int = damage.get_value()
		data.current_hp -= value
		hp_bar.value = float(data.current_hp) / float(data.max_hp)
		Signals.spawn_damage_number.emit(value, global_position, damage.type)
		if data.current_hp <= 0:
			data.current_hp = 0
			state = DEAD
			data.is_alive = false
			_update_body_animation(state)
			_spawn_loot()


func _body_animation_finished() -> void:
	if body.animation == &"death":
		Signals.enemy_dead.emit(global_position, self)


func _update_body_animation(_state := IDLE) -> void:
	match _state:
		SPAWNING:
			if body.animation != &"spawn": body.play(&"spawn")
		MOVING:
			if body.animation != &"move": body.play(&"move")
		DEAD:
			if body.animation != &"death": body.play(&"death")
		_:
			if body.animation != &"idle": body.play(&"idle")


func _flip_body() -> void:
	if global_position.x < player.global_position.x and body.flip_h:
		body.flip_h = false
		body.position.x = body_x
	elif global_position.x >= player.global_position.x and not body.flip_h:
		body.flip_h = true
		body.position.x = -body_x


func _spawn_loot() -> void:
	var loot := _get_loot()
	if not loot.is_empty():
		var keys := loot.keys()
		for k in keys:
			Signals.spawn_mech_part.emit(loot[k], global_position)


func _get_loot() -> Dictionary:
	var chance := randf()

	if chance <= data.chance_of_mech_part_drop:
		return data.mech_part_loot_table.get_loot(1)

	return {}