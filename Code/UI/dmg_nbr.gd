class_name DamageNumber extends Label


@export var lifetime := 0.3
@export var distance := 10.0


func display() -> void:
	var tween:Tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, position.y - distance), lifetime)
	await  tween.finished
	Signals.remove_damage_number.emit(self)
