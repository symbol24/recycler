class_name Damage extends Resource

enum Type {PHYSICAL, FIRE, POISON}

@export var base_value := 0
@export var type := Type.PHYSICAL
@export var base_crit_chance := 0.0
@export var base_crit_damage := 0.0
var attack_owner:CharacterBody2D

var value:int:
	get:
		return base_value + attack_owner.data.get_var(&"damage")
var cc:float:
	get:
		return base_value + attack_owner.data.get_var(&"crit_chance")
var cd:float:
	get:
		return base_value + attack_owner.data.get_var(&"crit_damage")
	
