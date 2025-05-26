class_name WeaponData extends Resource


enum Type {PROJECTILE, MELEE, LASER, FIXED, MOVING}


@export var damage:Damage
@export var type := Type.PROJECTILE
@export var projectile_speed := 30.0
@export var projectile_count := 1
@export var count_delay := 0.0
@export var shoot_delay := 2.0
@export var life_distance := 200.0
@export var attack_uid := ""
