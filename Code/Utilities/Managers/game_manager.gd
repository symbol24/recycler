class_name GameManager extends Node2D


@export_category("Characters")
@export var character:Array[CharacterData] = []

@export_category("Enemies")
@export var enemies:Array[EnemyData] = []

@onready var run_second_timer: Timer = %run_second_timer

var can_spawn_enemies := false:
	set(value):
		can_spawn_enemies = value
		Signals.ToggleEnemySpawning.emit(can_spawn_enemies)
var elite_spawned := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.InitNewRun.connect(_init_new_run)
	Signals.StartRunTimer.connect(_start_round_timer)
	Signals.EnemyDead.connect(_enemy_defeated)
	run_second_timer.timeout.connect(_run_second_timer_timeout)


func _init_new_run() -> void:
	Data.run_data = RunData.new()
	Data.run_data.round_timer = 0
	can_spawn_enemies = false
	elite_spawned = false


func _run_second_timer_timeout() -> void:
	Data.run_data.round_timer += 1
	Signals.UpdateTimer.emit(Data.run_data.round_timer)
	run_second_timer.start()
	if Data.run_data.round_timer >= Data.run_data.max_round_time and not elite_spawned: _spawn_elite()


func _start_round_timer() -> void:
	run_second_timer.start()
	can_spawn_enemies = true


func _spawn_elite() -> void:
	print("Spawning Elite!")
	elite_spawned = true
	var to_spawn:EnemyData.Type = EnemyData.Type.ELITE if Data.run_data.current_round < Data.run_data.max_round_count else EnemyData.Type.BOSS
	Signals.SpawnEnemyByType.emit(to_spawn)


func _enemy_defeated(_pos:Vector2, enemy:Enemy) -> void:
	if enemy.data.enemy_type in [EnemyData.Type.ELITE, EnemyData.Type.BOSS]:
		can_spawn_enemies = false
