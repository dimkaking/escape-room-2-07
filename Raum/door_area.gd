extends Area2D

@onready var approach_point = $ApproachPoint

func can_open_door(player_position: Vector2) -> bool:
	var distance_to_door = player_position.distance_to(approach_point.global_position)

	return distance_to_door < 60 and GameState.has_item("door_key")
