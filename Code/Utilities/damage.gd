class_name Damage extends Resource


enum Type {PHYSICAL, FIRE, POISON, HEAL}


@export var base_value := 0
@export var type := Type.PHYSICAL
@export var base_crit_chance := 0.0
@export var base_crit_damage := 0.0
var attack_owner:CharacterBody2D


func get_value() -> int:
	var check:float = randf()
	var crit:int = 0
	#print("Attack Owner starting_damage: ", attack_owner.data.starting_damage)
	var value:int = base_value + attack_owner.data.get_var(&"damage")
	var cc:float = base_crit_chance + attack_owner.data.get_var(&"crit_chance")
	var cd:float = base_value + attack_owner.data.get_var(&"crit_damage")
	if check <= cc:
		crit = int(value * cd)
	#print("Damage value: %s, CC: %s, CD: %s, check: %s, final: %s" % [value, cc, cd, check, value+crit])
	return value + crit
