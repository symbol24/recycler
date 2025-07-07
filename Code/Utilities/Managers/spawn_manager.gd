class_name SpawnManager extends Node2D


const DEBUGPLAYER := preload("uid://ce7w52outmc3j")
const DEBUGENEMY := preload("uid://di07qeiu452uf")
const DEBUGELITE := preload("uid://k7tu2lp68mil")
const DEBUGBOSS := preload("uid://dreabhugaeeyt")
const DEBUGMECHPART := preload("uid://bs8qq20nf2y6p")
const PLAYCAMERA := "uid://blwon3x85h06h"
const PLAYERSPAWN := Vector2(160, 90)
const MINSPAWNTIME := 1.0
const MAXSPAWNTIME := 3.0
const INNERRADIUS := 140.0
const OUTERRADIUS := 180.0
const PARTVERTOFFSET := 20.0


@export_category("Characters")
@export var characters:Array[CharacterData] = []

@export_category("Enemies")
@export var base_enemies:Array[EnemyData] = []
@export var elite_enemies:Array[EnemyData] = []
@export var boss_enemies:Array[EnemyData] = []

var _active_player:Character
var _play_camera:Camera2D
var _enemy_pool:Array[Array] = []
var _spawned_enemies:Array[Enemy] = []
var _spawn_timer := 0.0
var _next_spawn := 0.1
var _can_spawn_enemies := false
var _pool_mech_parts:Array[MechPartDrop] = []

var _enemy_layer:Node2D = null:
	get:
		if not is_instance_valid(_enemy_layer): _enemy_layer = get_tree().get_first_node_in_group(&"_enemy_layer")
		return _enemy_layer
var _player_layer:Node2D = null:
	get:
		if not is_instance_valid(_player_layer): _player_layer = get_tree().get_first_node_in_group(&"_player_layer")
		return _player_layer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	Signals.SpawnCharacter.connect(_spawn_character)
	Signals.EnemyDead.connect(_enemy_dead)
	Signals.ToggleEnemySpawning.connect(_toggle_can_spawn_enemies)
	Signals.SpawnEnemyByType.connect(_spawn_enemy)


func _process(delta: float) -> void:
	if _can_spawn_enemies:
		_spawn_timer += delta
		if _spawn_timer >= _next_spawn: _spawn_normal()


func _spawn_character(pos := PLAYERSPAWN) -> void:
	if is_instance_valid(_active_player):
		var temp = _active_player
		_active_player = null
		temp.queue_free.call_deferred()

	var selected:StringName = &"" if Data.run_data == null or Data.run_data.selected_character == &"" else Data.run_data.selected_character
	var character_data:CharacterData = _get_character_data(selected).duplicate(true)
	_active_player = load(character_data.uid).instantiate()
	_player_layer.add_child(_active_player)
	if not _active_player.is_node_ready(): await _active_player.ready
	_active_player.setup_character(character_data)
	_active_player.global_position = pos

	if is_instance_valid(_play_camera):
		_active_player.remove_child(_play_camera)
		var temp = _play_camera
		_play_camera = null
		temp.queue_free.call_deferred()

	_play_camera = load(PLAYCAMERA).instantiate()
	_active_player.add_child(_play_camera)
	_play_camera.position = Vector2.ZERO


func _get_character_data(id := &"") -> CharacterData:
	var result:CharacterData = null
	if id == &"": result = DEBUGPLAYER
	else:
		pass

	return result


func _get_enemy_data(type := EnemyData.Type.NORMAL) -> EnemyData:
	var result:EnemyData
	match type:
		EnemyData.Type.ELITE:
			result = DEBUGELITE
		EnemyData.Type.BOSS:
			result = DEBUGBOSS
		_:
			result = DEBUGENEMY
	return result


func _spawn_normal() -> void:
	_spawn_enemy()
	_next_spawn = randf_range(MINSPAWNTIME, MAXSPAWNTIME)
	_spawn_timer = 0.0


func _spawn_enemy(type:EnemyData.Type = EnemyData.Type.NORMAL) -> void:
	var new:Enemy = _get_enemy(type)
	_enemy_layer.add_child(new)
	if not new.is_node_ready(): await new.ready
	var data:EnemyData = _get_enemy_data(type)
	new.setup_character(data)
	new.global_position = _get_spawn_coords()
	_spawned_enemies.append(new)


func _get_enemy(type:EnemyData.Type = EnemyData.Type.NORMAL) -> Enemy:
	for each in _enemy_pool:
		if not each.is_empty() and is_instance_valid(each[0]) and each[0].data.enemy_type == type:
			return each.pop_front()

	var data:EnemyData = _get_enemy_data(type)
	var result:Enemy = load(data.uid).instantiate()
	return result


func _enemy_dead(_pos:Vector2, enemy:Enemy) -> void:
	_enemy_layer.remove_child(enemy)

	var found := false
	var i := 0
	for each in _spawned_enemies:
		if is_instance_valid(each) and each == enemy:
			found = true
			break
		i += 1
	if found:
		_spawned_enemies.remove_at(i)
		if _spawned_enemies.is_empty(): Signals.EndRound.emit()

	found = false
	for each in _enemy_pool:
		if not found and not each.is_empty() and is_instance_valid(each[0]) and each[0].data.id == enemy.data.id:
			each.append(enemy)
			found = true

	if not found:
		_enemy_pool.append([enemy])


func _toggle_can_spawn_enemies(value := false) -> void:
	_can_spawn_enemies = value


func _get_spawn_coords() -> Vector2:
	var min_sq_radius = INNERRADIUS * INNERRADIUS
	var max_sq_radius = OUTERRADIUS * OUTERRADIUS
	var random_sq_radius = randf_range(min_sq_radius, max_sq_radius)
	var random_radius = sqrt(random_sq_radius)

	var random_angle = randf_range(0, TAU)

	var x = random_radius * cos(random_angle)
	var y = random_radius * sin(random_angle)
	return Vector2(x, y) + _active_player.global_position


func _spawn_mech_part(_mech_part_data:MechPartData, _pos:Vector2) -> void:
	if _mech_part_data != null:
		var part := _get_mech_part_object()
		_player_layer.add_child(part)
		if not part.is_node_ready(): await part.ready
		part.setup_mech_part_drop(_mech_part_data, _pos, Vector2(_pos.x, _pos.y - PARTVERTOFFSET))
		part.play_drop()


func _get_mech_part_object() -> MechPartDrop:
	if not _pool_mech_parts.is_empty(): return _pool_mech_parts.pop_front()

	return DEBUGMECHPART.instantiate()