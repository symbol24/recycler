class_name HurtBox extends Area2D


var parent:CharacterBody2D = null:
	get:
		if parent == null: parent = get_parent() as CharacterBody2D
		return parent
var can_receive := true
var collider:CollisionShape2D = null:
	get:
		if collider == null: collider = get_child(0) as CollisionShape2D
		return collider


func _ready() -> void:
	area_entered.connect(_area_entered)


func toggle_hurtbox(value := false) -> void:
	if value: collider.disabled = false
	else: collider.disabled = true
		


func _area_entered(area:Area2D) -> void:
	if area.has_method(&"get_damage") and can_receive and parent.data.is_alive:
		can_receive = false
		parent.receive_damage(area.get_damage())
		get_tree().create_timer(parent.data.get_var(&"invulnerability_time")).timeout.connect(_reset_invul)


func _reset_invul() -> void:
	can_receive = true
