extends CanvasLayer


const PLAYERUI := "uid://cwabm6nlxsd5e"


var screens:Array[RidControl] = []
var previous := &""
var mouse_controls := true


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.ToggleDisplay.connect(_toggle_display)


func _toggle_display(to_toggle := &"", _previous := &"", display := false) -> void:
	for each in screens: each.toggle_display(false)
	var screen:RidControl = _get_rid(to_toggle)
	screen.toggle_display(display)
	previous = _previous


func _get_rid(_name := &"") -> RidControl:
	for each in screens:
		if each.id == _name: return each
	return _get_new_control(_name)


func _get_new_control(_name := &"") -> RidControl:
	var new_rid:RidControl
	match _name:
		_:
			new_rid = load(PLAYERUI).instantiate()
	screens.append(new_rid)
	add_child(new_rid)
	return new_rid
