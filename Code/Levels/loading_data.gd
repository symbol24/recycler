class_name LoadingData extends Resource


@export var level_datas:Array[LevelData] = []

var levels:Dictionary = {}


func create_dict() -> void:
	for each in level_datas:
		levels[each.id] = each


func get_level(id := &"") -> LevelData:
	if levels.has(id): 
		#print("Level data for id: ", levels[id])
		return levels[id]
	return null
