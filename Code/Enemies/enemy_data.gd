class_name EnemyData extends CharacterData


enum Type {NORMAL, ELITE, BOSS}


@export var enemy_type:Type = Type.NORMAL
@export var is_juiced := false
@export var mech_part_loot_table:LootTable
@export var chance_of_mech_part_drop := 0.2