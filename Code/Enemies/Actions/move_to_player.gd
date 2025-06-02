class_name MoveToPlayer extends EnemyAction


var direction:Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	if is_instance_valid(parent) and parent.data:
		direction = global_position.direction_to(parent.player.global_position)
		parent.velocity = _move(parent.velocity, direction, delta)


func _move(_current := Vector2.ZERO, _direction := Vector2.ZERO, _delta := 0.0) -> Vector2:
	var x := _current.x
	var y := _current.y

	if _direction == Vector2.ZERO:
		x = move_toward(_current.x, 0.0, _delta * parent.data.friction)
		y = move_toward(_current.x, 0.0, _delta * parent.data.friction)
	else:
		x = move_toward(_current.x, _direction.x * parent.data.get_var(&"speed"), _delta * parent.data.friction)
		y = move_toward(_current.y, _direction.y * parent.data.get_var(&"speed"), _delta * parent.data.acceleration)
	
	return Vector2(x, y)
