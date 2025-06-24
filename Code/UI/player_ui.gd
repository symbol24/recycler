class_name PlayerUi extends RidControl


const RETICLE := "uid://d25vcug412rou"


@onready var timer: Label = %timer

var reticle:Sprite2D = null


func _ready() -> void:
	Signals.UpdateTimer.connect(_update_timer)
	Signals.SpawnReticle.connect(_spawn_reticle)


func _process(_delta: float) -> void:
	if UI.mouse_controls and is_instance_valid(reticle): 
		reticle.position = get_local_mouse_position()
		Signals.ReticlePosition.emit(reticle.global_position)


func _spawn_reticle() -> void:
	if not is_instance_valid(reticle): reticle = load(RETICLE).instantiate()
	add_child(reticle)
	if not reticle.is_node_ready(): await reticle.ready
	reticle.position = get_local_mouse_position()
	Signals.ReticleReady.emit(reticle)


func _update_timer(value := 0) -> void:
	timer.text = str(value)
