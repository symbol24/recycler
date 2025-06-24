class_name SpawnManager extends Node2D


const DEBUGPLAYER := preload("uid://ce7w52outmc3j")
const DEBUGENEMY := preload("uid://di07qeiu452uf")
const DEBUGELITE := preload("uid://k7tu2lp68mil")
const DEBUGBOSS := preload("uid://dreabhugaeeyt")
const PLAYERSPAWN := Vector2(160, 90)
const MINSPAWNTIME := 1.0
const MAXSPAWNTIME := 3.0
const INNERRADIUS := 140.0
const OUTERRADIUS := 180.0


@export_category("Characters")
@export var characters:Array[CharacterData] = []

@export_category("Enemies")
@export var base_enemies:Array[EnemyData] = []
@export var elite_enemies:Array[EnemyData] = []
@export var boss_enemies:Array[EnemyData] = []


var active_player:Character
var instantiated_enemies:Dictionary[StringName, PackedScene] = {}
var enemy_pool:Array[Array] = []
var enemy_count := 0
var spawn_timer := 0.0
var next_spawn := 0.1
var can_spawn_enemies := false

var enemy_layer:Node2D = null:
	get:
		if not is_instance_valid(enemy_layer): enemy_layer = get_tree().get_first_node_in_group(&"enemy_layer")
		return enemy_layer
var player_layer:Node2D = null:
	get:
		if not is_instance_valid(player_layer): player_layer = get_tree().get_first_node_in_group(&"player_layer")
		return player_layer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	Signals.SpawnCharacter.connect(_spawn_character)
	Signals.EnemyDead.connect(_enemy_dead)
	Signals.ToggleEnemySpawning.connect(_toggle_can_spawn_enemies)
	Signals.SpawnEnemyByType.connect(_spawn_enemy)


func _process(delta: float) -> void:
	if can_spawn_enemies:
		spawn_timer += delta
		if spawn_timer >= next_spawn: _spawn_normal()


func _spawn_character(pos := PLAYERSPAWN) -> void:
	if active_player != null:
		var temp = active_player
		active_player = null
		temp.queue_free.call_deferred()
	
	var selected:StringName = &"" if Data.run_data == null or Data.run_data.selected_character == &"" else Data.run_data.selected_character
	var character_data:CharacterData = _get_character_data(selected).duplicate(true)
	active_player = load(character_data.uid).instantiate()
	player_layer.add_child(active_player)
	if not active_player.is_node_ready(): await active_player.ready
	active_player.setup_character(character_data)
	active_player.global_position = pos
	
	
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
	next_spawn = randf_range(MINSPAWNTIME, MAXSPAWNTIME)
	spawn_timer = 0.0


func _spawn_enemy(type:EnemyData.Type = EnemyData.Type.NORMAL) -> void:
	var new:Enemy = _get_enemy(type)
	enemy_layer.add_child(new)
	if not new.is_node_ready(): await new.ready
	var data:EnemyData = _get_enemy_data(type)
	new.setup_character(data)
	new.global_position = _get_spawn_coords()


func _get_enemy(type:EnemyData.Type = EnemyData.Type.NORMAL) -> Enemy:
	for each in enemy_pool:
		if not each.is_empty() and is_instance_valid(each[0]) and each[0].data.enemy_type == type:
			return each.pop_front()
	
	var data:EnemyData = _get_enemy_data(type)
	var result:Enemy = load(data.uid).instantiate()
	return result


func _enemy_dead(_ssspos:Vector2, enemy:Enemy) -> void:
	enemy_layer.remove_child(enemy)
	
	var found := false
	for each in enemy_pool:
		if not each.is_empty() and is_instance_valid(each[0]) and each[0].data.id == enemy.data.id:
			each.append(enemy)
			found = true
	
	if not found:
		enemy_pool.append([enemy])
	

func _toggle_can_spawn_enemies(value := false) -> void:
	can_spawn_enemies = value


func _get_spawn_coords() -> Vector2:
	var min_sq_radius = INNERRADIUS * INNERRADIUS
	var max_sq_radius = OUTERRADIUS * OUTERRADIUS
	var random_sq_radius = randf_range(min_sq_radius, max_sq_radius)
	var random_radius = sqrt(random_sq_radius)

	var random_angle = randf_range(0, TAU)

	var x = random_radius * cos(random_angle)
	var y = random_radius * sin(random_angle)
	return Vector2(x, y) + active_player.global_position
