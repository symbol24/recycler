class_name Character extends CharacterBody2D


const SPAWNYMOVE := 2.0


enum {DEAD, SPAWNING, IDLE, MOVING}


@export var debug_data:CharacterData
@export var debug_spawn := false

@onready var body: AnimatedSprite2D = %body
@onready var weapon: AnimatedSprite2D = %weapon
@onready var weapon_flash: AnimatedSprite2D = %weapon_flash
@onready var proj_spawn_point: Marker2D = %proj_spawn_point

var data:CharacterData
var state := SPAWNING
var body_x := 0.0


func _ready() -> void:
	Signals.ReticlePosition.connect(_flip_weapon)
	body_x = body.position.x
	if debug_spawn: setup_character()
	weapon_flash.hide()
	var children = get_children()
	if not children[-1].is_node_ready(): await children[-1].ready
	Signals.CharacterReady.emit(self)


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


func _update_body_animation(_state := IDLE) -> void:
	match _state:
		MOVING:
			if body.animation != &"move": body.play(&"move")
		_:
			if body.animation != &"idle": body.play(&"idle")


func _flip_body() -> void:
	if velocity.x > 0.0 and body.flip_h:
		body.flip_h = false
		body.position.x = body_x
	elif velocity.x < 0.0 and not body.flip_h:
		body.flip_h = true
		body.position.x = -body_x


func _flip_weapon(reticle_pos := Vector2.ZERO) -> void:
	if reticle_pos.x < global_position.x and not weapon.flip_v:
		weapon.flip_v = true
		proj_spawn_point.position.y += SPAWNYMOVE
		weapon_flash.position.y += SPAWNYMOVE
	elif reticle_pos.x >= global_position.x and weapon.flip_v:
		weapon.flip_v = false
		proj_spawn_point.position.y -= SPAWNYMOVE
		weapon_flash.position.y -= SPAWNYMOVE
