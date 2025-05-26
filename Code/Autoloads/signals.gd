extends Node2D


# Character
signal CharacterReady(character:Character)
signal ReticlePosition(pos:Vector2)
signal SpawnReticle()
signal ReticleReady(reticle:Sprite2D)

# UI
signal ToggleDisplay(to_toggle:StringName, previous:StringName, display:bool)
