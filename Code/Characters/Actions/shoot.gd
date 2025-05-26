class_name CharacterShoot extends CharacterAction


@export var weapon_data:WeaponData
@export var spawn_point:Marker2D

var shooting := false
var cycling := false
var current_count := 0
var bullet_pool:Array[Projectile] = []
var projectile:PackedScene = null
var projectile_layer:Node2D:
	get:
		if projectile_layer == null: projectile_layer = get_tree().get_first_node_in_group(&"projectile_layer")
		return projectile_layer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skill1"): shooting = true
	elif event.is_action_released("skill1"): shooting = false


func _process(_delta: float) -> void:
	if shooting and not cycling:
		cycling = true
		_shoot()


func _shoot() -> void:
	if current_count < weapon_data.projectile_count:
		_spawn_bullet()
		current_count += 1
		if weapon_data.count_delay > 0.0: get_tree().create_timer(weapon_data.count_delay).timeout.connect(_shoot)
		else: get_tree().create_timer(weapon_data.shoot_delay).timeout.connect(_end_shoot)
	else:
		get_tree().create_timer(weapon_data.shoot_delay).timeout.connect(_end_shoot)


func _end_shoot() -> void:
	current_count = 0
	cycling = false
	

func _spawn_bullet() -> void:
	var new_proj:Projectile = _get_bullet()
	if is_instance_valid(new_proj):
		projectile_layer.add_child(new_proj)
		if not new_proj.is_node_ready(): await new_proj.ready
		new_proj.set_data(weapon_data.projectile_speed, spawn_point.global_position, weapon_data.life_distance, parent.weapon.rotation)
		new_proj.trigger()


func _get_bullet() -> Projectile:
	if bullet_pool.is_empty():
		assert(weapon_data != null, "Weapon Data is missing from %s." % name)
		if not is_instance_valid(projectile): projectile = load(weapon_data.attack_uid)
		return projectile.instantiate()
	else:
		return bullet_pool.pop_front()
