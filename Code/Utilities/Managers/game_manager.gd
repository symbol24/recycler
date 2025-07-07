class_name GameManager extends Node2D


@onready var run_second_timer: Timer = %run_second_timer

var can_spawn_enemies := false:
	set(value):
		can_spawn_enemies = value
		Signals.toggle_enemy_spawning.emit(can_spawn_enemies)
var elite_spawned := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.init_new_run.connect(_init_new_run)
	Signals.start_new_run.connect(_start_round_timer)
	Signals.enemy_dead.connect(_enemy_defeated)
	Signals.end_round.connect(_end_round)
	Signals.start_next_round.connect(_start_next_round)
	run_second_timer.timeout.connect(_run_second_timer_timeout)


func _init_new_run() -> void:
	Data.run_data = RunData.new()
	Data.run_data.round_timer = 0
	can_spawn_enemies = false
	elite_spawned = false
	

func _start_next_round() -> void:
	if Data.run_data.current_round < Data.run_data.max_round_count:
		Data.run_data.current_round += 1
		Data.run_data.round_timer = 0.0
		elite_spawned = false
		get_tree().paused = false
		Signals.show_start_timer.emit()


func _run_second_timer_timeout() -> void:
	Data.run_data.round_timer += 1
	Signals.update_timer.emit(Data.run_data.round_timer)
	run_second_timer.start()
	if Data.run_data.round_timer >= Data.run_data.max_round_time and not elite_spawned: _spawn_elite()


func _start_round_timer() -> void:
	run_second_timer.start()
	can_spawn_enemies = true


func _spawn_elite() -> void:
	elite_spawned = true
	var to_spawn:EnemyData.Type = EnemyData.Type.ELITE if Data.run_data.current_round < Data.run_data.max_round_count else EnemyData.Type.BOSS
	Signals.spawn_enemy_by_type.emit(to_spawn)


func _enemy_defeated(_pos:Vector2, enemy:Enemy) -> void:
	if enemy.data.enemy_type in [EnemyData.Type.ELITE, EnemyData.Type.BOSS]:
		can_spawn_enemies = false


func _end_round() -> void:
	run_second_timer.stop()
	get_tree().paused = true
	Signals.toggle_display.emit(&"end_round", &"player_ui", true)
