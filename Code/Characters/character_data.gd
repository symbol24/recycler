class_name CharacterData extends Resource


@export_category("Movement")
@export var acceleration := 500.0
@export var friction := 400.0
@export var starting_speed := 20.0

@export_category("Health")
@export var starting_hp := 100
@export var starting_damage_reduction := 0
@export var starting_damage_negate := 0.0
@export var starting_invulnerability_time := 0.2

@export_category("Skills")
@export var starting_skill_speed := 1.0

@export_category("Damage")
@export var starting_damage := 0.0
@export var starting_crit_chance := 0.0
@export var starting_crit_damage := 0.0

@export_category("Drops and More")
@export var starting_xp_gain := 0.0
@export var starting_currency_drop := 0.0
@export var starting_parts_drop := 0.0
@export var starting_attachment_points := 2

@export_category("Extras")
@export var uid := ""
@export var id := &""

var current_hp:int
var max_hp:int
var current_exp := 0
var total_exp := 0
var current_level := 1
var is_alive := false


func setup_data() -> void:
	max_hp = get_var(&"hp")
	current_hp = max_hp
	is_alive = true


func get_var(variable := &"") -> Variant:
	if get(&"starting_" + variable) != null:
		#if variable != &"speed": print("Variable %s: %s" % [variable, get(&"starting_" + variable)])
		return get(&"starting_" + variable)
	
	#print(variable, " not found")
	return 0
