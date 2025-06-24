class_name Manager extends Node2D


const GAME := "uid://h551enkad4pv"
const SPAWN := "uid://cte5uvltxj7xl"
const EXTRA_TIME := 1.0


@export var level_loading_data:LoadingData

var managers:Array[Node] = []
var to_load := &""
var loading := false
var level_data:LevelData
var active_level:Node2D
var load_complete := false
var loading_status:ResourceLoader.ThreadLoadStatus
var progress := []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.StartManager.connect(_start_manager)
	Signals.KillManager.connect(_kill_manager)
	Signals.LoadLevel.connect(_load_level)
	level_loading_data.create_dict()


func _process(_delta: float) -> void:
	if loading:
		loading_status = ResourceLoader.load_threaded_get_status(level_data.uid, progress)
		#print("loading ", to_load , ": ", progress[0]*100, "%")
		if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if not load_complete:
				load_complete = true
				_complete_load()


func _load_level(id := &"", loading_screen := true) -> void:
	#print("Received id: ", id)
	if loading_screen: Signals.ToggleLoadingScreen.emit(true)
	to_load = id
	level_data = null
	load_complete = false
	loading_status = ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE
	get_tree().paused = true
	level_data = level_loading_data.get_level(to_load)
	assert(level_data != null, "Level list does not contain %s" % to_load)
	
	if active_level != null:
		var temp = active_level
		active_level = null
		remove_child(temp)
		temp.queue_free.call_deferred()
	
	ResourceLoader.load_threaded_request(level_data.uid)
	loading = true
	loading_status = ResourceLoader.load_threaded_get_status(level_data.uid, progress)
	assert(loading_status != 0, "Trying to load an invalid resource. But why isit invalid?!")


func _complete_load() -> void:
	loading = false
	active_level = ResourceLoader.load_threaded_get(level_data.uid).instantiate()
	add_child(active_level)
	if not active_level.is_node_ready(): await active_level.ready
	await get_tree().create_timer(EXTRA_TIME).timeout
	get_tree().paused = false
	Signals.ToggleLoadingScreen.emit(false)


func _start_manager(id := &"") -> void:
	var uid:String = _get_uid(id)
	if uid != "" and not _already_spawned(id):
		var new:Node2D = load(uid).instantiate()
		add_child(new)
		if new.is_node_ready(): await new.ready
		managers.append(new)


func _kill_manager(id := &"") -> void:
	if _already_spawned(id):
		var to_kill:Node2D = null
		var pos := 0
		var found := false
		for each in managers:
			if each.is_in_group(id):
				found = true
				break
			pos += 1
		if found:
			to_kill = managers.pop_at(pos)
			remove_child(to_kill)
			to_kill.queue_free.call_deferred()


func _get_uid(id := &"") -> String:
	var result := ""
	match id:
		&"game_manager":
			result = GAME
		&"spawn_manager":
			result = SPAWN
		_:
			pass
	return result


func _already_spawned(id := &"") -> bool:
	var result := false
	for each in managers:
		if each.is_in_group(id):
			result = true
			break
	return result
