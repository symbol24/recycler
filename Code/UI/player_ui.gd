class_name PlayerUi extends RidControl


const RETICLE := "uid://d25vcug412rou"


var reticle:Sprite2D = null

@onready var timer: Label = %timer
@onready var start_timer: Label = %start_timer
@onready var start_animator: AnimationPlayer = %start_animator


func _ready() -> void:
	Signals.update_timer.connect(_update_timer)
	Signals.spawn_reticle.connect(_spawn_reticle)
	Signals.show_start_timer.connect(_show_start_timer)


func _process(_delta: float) -> void:
	if UI.mouse_controls and is_instance_valid(reticle):
		reticle.position = get_local_mouse_position()
		Signals.reticle_position.emit(reticle.global_position)


func _spawn_reticle() -> void:
	if not is_instance_valid(reticle): reticle = load(RETICLE).instantiate()
	add_child(reticle)
	if not reticle.is_node_ready(): await reticle.ready
	reticle.position = get_local_mouse_position()
	Signals.reticle_ready.emit(reticle)


func _update_timer(value := 0) -> void:
	timer.text = str(value)


func _show_start_timer() -> void:
	await get_tree().create_timer(2).timeout
	start_timer.text = "Ready"
	start_timer.show()
	start_animator.play(&"start")
	await start_animator.animation_finished
	start_timer.hide()
	start_timer.text = "GO!"
	start_timer.show()
	Signals.start_new_run.emit()
	start_animator.play(&"start")
	await start_animator.animation_finished
	start_timer.hide()
