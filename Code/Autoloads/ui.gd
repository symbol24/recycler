extends CanvasLayer


const PLAYERUI := "uid://cwabm6nlxsd5e"
const LOADING := "uid://bl0x8fggjhu8h"
const MAINMENU := "uid://c6itlfnxoswt0"
const ENDROUND := "uid://c6iaw7ntjlw4a"


var screens:Array[RidControl] = []
var loading:LoadingScreen
var previous := &""
var mouse_controls := true


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.ToggleDisplay.connect(_toggle_display)
	Signals.ToggleLoadingScreen.connect(_toggle_loading_screen)


func _toggle_display(to_toggle := &"", _previous := &"", display := true) -> void:
	for each in screens: each.toggle_display(false)
	var screen:RidControl = _get_rid(to_toggle)
	screen.toggle_display(display)
	previous = _previous


func _toggle_loading_screen(display := false) -> void:
	if loading == null:
		loading = load(LOADING).instantiate()
		add_child(loading)
		if not loading.is_node_ready(): await loading.ready
	
	if display:
		if loading.get_index() != get_child_count(): move_child(loading, get_child_count())
		loading.show()
	else:
		loading.hide()


func _get_rid(_name := &"") -> RidControl:
	for each in screens:
		if each.id == _name: return each
	return _get_new_control(_name)


func _get_new_control(_name := &"") -> RidControl:
	var new_rid:RidControl
	match _name:
		&"main_menu":
			new_rid = load(MAINMENU).instantiate()
		&"end_round":
			new_rid = load(ENDROUND).instantiate()
		_:
			new_rid = load(PLAYERUI).instantiate()
	screens.append(new_rid)
	add_child(new_rid)
	return new_rid
