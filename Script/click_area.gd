extends Area2D

@export var task_number := 1
@export var minigame_scene_path := ""

@onready var approach_point = $"../ApproachPoint"


func can_start_minigame(player_position: Vector2) -> bool:
	var distance_to_table = player_position.distance_to(approach_point.global_position)

	return (
		distance_to_table < 45
		and GameState.can_start_task(task_number)
		and minigame_scene_path != ""
	)
