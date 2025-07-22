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
var mech_parts:Array[MechPartData] = []
var round_pickups:Array[MechPartData] = []


func setup_data() -> void:
	max_hp = get_var(&"hp")
	current_hp = max_hp
	if not mech_parts.is_empty(): mech_parts.clear()
	is_alive = true


func pickup_merch_part_data(new:MechPartData) -> void:
	assert(new != null, "Character data received null mech part data on pickup.")
	round_pickups.append(new.duplicate(true))


func add_mech_part_data(part:MechPartData = null) -> void:
	if part != null:
		mech_parts.append(part.duplicate(true))


func upgrade_mech_part(part:MechPartData = null) -> void:
	var to_upgrade:MechPartData = null
	if part != null:
		for each in mech_parts:
			if part.id == each.id:
				to_upgrade = each
				break

		if to_upgrade != null:
			to_upgrade.level += 1


func remove_mech_part_data(part:MechPartData = null) -> void:
	var i := 0
	var found := false
	if part != null:
		for each in mech_parts:
			if each.id == part.id:
				found = true
				break
			i += 1

		if found:
			mech_parts.remove_at(i)


func get_var(variable := &"") -> Variant:
	var result
	if get(&"starting_" + variable) != null:
		result = get(&"starting_" + variable)
		for each in mech_parts:
			result += each.get_stat(variable)

	return result
