extends Node2D


#Managers
signal StartManager(id:StringName)
signal KillManager(id:StringName)
signal LoadLevel(id:StringName, loading_screen:bool)
signal SpawnCharacter(pos:Vector2)
signal InitNewRun()
signal StartRunTimer()
signal SpawnEnemyByType(type:EnemyData.Type)
signal ToggleEnemySpawning(value:bool)
signal EndRound()
signal StartNextRound()

# Character
signal CharacterReady(character:Character)
signal ReticlePosition(pos:Vector2)
signal SpawnReticle()
signal ReticleReady(reticle:Sprite2D)
signal CharacterDead(character:Character)

# UI
signal ToggleDisplay(to_toggle:StringName, previous:StringName, display:bool)
signal ToggleLoadingScreen(display:bool)
signal SpawnDamageNumber(value:int, location:Vector2, type:Damage.Type)
signal RemoveDamageNumber(dmgnbr:Label)
signal HpUpdated(current_hp:int, max_hp:int)
signal UpdateTimer(value:int)
signal ShowStartTimer()
signal DisplayPopup(id:StringName, is_large:bool, title:String, text:String, timer:int)
signal ReturnPopupResult(popup_id:StringName, result:bool)

# ENEMIES
signal EnemyDead(location:Vector2, enemy:Enemy)
