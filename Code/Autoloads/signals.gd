extends Node2D


# Character
signal CharacterReady(character:Character)
signal ReticlePosition(pos:Vector2)
signal SpawnReticle()
signal ReticleReady(reticle:Sprite2D)
signal CharacterDead(character:Character)

# UI
signal ToggleDisplay(to_toggle:StringName, previous:StringName, display:bool)
signal SpawnDamageNumber(value:int, location:Vector2, type:Damage.Type)
signal RemoveDamageNumber(dmgnbr:Label)
signal HpUpdated(current_hp:int, max_hp:int)

# ENEMIES
signal EnemyDead(location:Vector2, data:EnemyData)
