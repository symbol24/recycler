class_name Enemy extends CharacterBody2D


enum {DEAD, SPAWNING, IDLE, MOVING}


@export var debug_data:EnemyData
@export var debug_spawn := false

@onready var body: AnimatedSprite2D = %body

var data:EnemyData
var state := SPAWNING
var body_x := 0.0
var player:Character = null:
	get: 
		if player == null: player = get_tree().get_first_node_in_group(&"player")
		return player


func _ready() -> void:
	body_x = body.position.x
	if debug_spawn: setup_character()
	

func _process(_delta: float) -> void:
	if state in [IDLE, MOVING]:
		if state == IDLE and velocity.length_squared() > 0.0: state = MOVING
		elif state == MOVING and velocity.length() == 0.0: state = IDLE
		_update_body_animation(state)
		_flip_body()
		#move_and_slide()


func setup_character(new_data := debug_data) -> void:
	assert(new_data != null, "Data is missing from %s." % name)
	data = new_data.duplicate()
	data.setup_data()
	state = IDLE


func receive_damage(damage:Damage) -> void:
	pass


func _update_body_animation(_state := IDLE) -> void:
	match _state:
		MOVING:
			if body.animation != &"move": body.play(&"move")
		_:
			if body.animation != &"idle": body.play(&"idle")


func _flip_body() -> void:
	if global_position.x < player.global_position.x and body.flip_h:
		body.flip_h = false
		body.position.x = body_x
	elif global_position.x >= player.global_position.x and not body.flip_h:
		body.flip_h = true
		body.position.x = -body_x
