class_name LoadingScreen extends Control


@export var delay := 0.5

@onready var loading: Label = %loading


var current := 0
var timer := 0.0:
	set(value):
		timer = value
		if timer >= delay:
			timer = 0.0
			_tick()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	loading.visible_characters = 0


func _process(delta: float) -> void:
	if visible:
		timer += delta


func _tick() -> void:
	current += 1
	if current > loading.get_total_character_count(): current = 0
	loading.visible_characters = current
