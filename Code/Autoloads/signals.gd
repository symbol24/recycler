extends Node2D

#Managers
signal start_manager(id: StringName)
signal kill_manager(id: StringName)
signal load_level(id: StringName, loading_screen: bool)
signal spawn_character(pos: Vector2)
signal init_new_run
signal start_new_run
signal spawn_enemy_by_type(type: EnemyData.Type)
signal toggle_enemy_spawning(value: bool)
signal end_round
signal start_next_round
signal spawn_mech_part(data:MechPartData, pos:Vector2)
signal return_mech_part_drop(drop:MechPartDrop)

# Character
signal character_ready(character: Character)
signal reticle_position(pos: Vector2)
signal spawn_reticle
signal reticle_ready(reticle: Sprite2D)
signal character_dead(character: Character)

# UI
signal toggle_display(to_toggle: StringName, previous: StringName, display: bool)
signal toggle_loading_screen(display: bool)
signal spawn_damage_number(value: int, location: Vector2, type: Damage.Type)
signal remove_damage_number(dmgnbr: Label)
signal hp_updated(current_hp: int, max_hp: int)
signal update_timer(value: int)
signal show_start_timer
signal display_popup(id: StringName, is_large: bool, title: String, text: String, timed: bool)
signal return_pupup_result(popup_id: StringName, result: bool)

# ENEMIES
signal enemy_dead(location: Vector2, enemy: Enemy)
