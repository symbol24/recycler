class_name Projectile extends Attack


@export var base_speed := 30.0

var active := false
var direction := Vector2.RIGHT
var speed := 30.0
var start_pos := Vector2.ZERO
var target := 1.0
var parent_transform:Transform2D


func _process(delta: float) -> void:
	if active: 
		global_position  += direction * speed * delta
		if global_position.distance_squared_to(start_pos) >= target: _destroy()


func set_data(new_speed := base_speed, new_pos := Vector2.ZERO, life_distance := 2.0, new_rot := 0.0) -> void:
	active = false
	speed = new_speed
	global_position = new_pos
	start_pos = global_position
	target = life_distance * life_distance
	rotation = new_rot
	direction = direction.rotated(rotation)


func trigger() -> void:
	active = true


func get_damage() -> Damage:
	active = false
	get_tree().create_timer(0.02).timeout.connect(_destroy)
	if damage: damage.attack_owner = attack_owner
	else: 
		damage = Damage.new()
		damage.attack_owner = attack_owner
	return damage
	

func _destroy() -> void:
	active = false
	queue_free()
