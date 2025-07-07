class_name CharacterAim extends CharacterAction


var reticle:Sprite2D = null


func _ready() -> void:
	super()
	await get_tree().create_timer(0.5).timeout
	Signals.spawn_reticle.emit()
	

func _process(_delta: float) -> void:
	if UI.mouse_controls and is_instance_valid(parent.weapon):
		parent.weapon.rotate(parent.weapon.get_angle_to(get_global_mouse_position()))
