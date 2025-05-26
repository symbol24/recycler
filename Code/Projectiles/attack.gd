class_name Attack extends Area2D


@export var damage:Damage

var attack_owner:CharacterBody2D


func _ready() -> void:
	area_entered.connect(_area_entered)


func get_damage() -> Damage:
	if damage: damage.attack_owner = attack_owner
	else: 
		damage = Damage.new()
		damage.attack_owner = attack_owner
	return damage


func _area_entered(_area:Area2D) -> void:
	pass
