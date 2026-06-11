extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MenuMusic.stop_music() # Replace with function body.
	if GameState.has_return_position:
		$Raum_2_07/character_body_2d.global_position = GameState.player_return_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
