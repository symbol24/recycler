class_name LootTable extends Resource


@export var id := &""
@export var loot_table:Array[Dictionary] = []

var _table:Dictionary = {}
var _total := 0


func setup_table() -> void:
	for each in loot_table:
		assert(each.has(&"weight") and each.has(&"item"), "Loot Table %s has an wrong loot_table entry. Requires weight and item." % id)
		_total += each[&"weight"]
		_table[_total] = each[&"item"]
	print(_table)


func get_loot(amount := 1, unique_loot := true) -> Dictionary:
	if _table.is_empty(): setup_table()

	assert(not _table.is_empty(), "Loot table %s is empty." % id)
	assert(not(unique_loot and amount > _table.size()), "Available loot in table %s smaller than required amount %s." % [id, amount])

	var check := -1
	var result := {}

	while result.size() < amount:
		check = randi_range(0, _total)
		var keys := _table.keys()
		for k in keys:
			if check <= k and (unique_loot and not result.has(k)):
				result[k] = _table[k]

	return result
