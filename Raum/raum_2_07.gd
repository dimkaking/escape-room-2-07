extends Node2D

func _ready() -> void:
	MenuMusic.stop_music()

	if GameState.has_return_position:
		$Raum_2_07/Player.global_position = GameState.player_return_position
