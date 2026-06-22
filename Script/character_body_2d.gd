extends CharacterBody2D

enum {
	DOWN,
	UP,
	LEFT,
	RIGHT
}

@onready var anim = $AnimatedSprite2D
@onready var target_arrow = $TargetArrow
@onready var nav_agent = $NavigationAgent2D

@export var foot_offset := Vector2(0, 10)
@export var speed := 200.0

var arrow_position: Vector2
var clicked_on_obstacle := false
var moving := false
var idle_dir = DOWN

var current_clicked_area = null


func _ready():
	target_arrow.visible = false
	target_arrow.top_level = true

	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 8.0

	if target_arrow.sprite_frames.has_animation("default"):
		target_arrow.play("default")


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			handle_mouse_click()


func handle_mouse_click():
	var click_position = get_global_mouse_position()
	arrow_position = click_position

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = click_position
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var results = space_state.intersect_point(query)

	for result in results:
		var clicked_area = result.collider

		if clicked_area.is_in_group("interactable_table"):
			handle_table_click(clicked_area, click_position)
			return
		if clicked_area.is_in_group("interactable_door"):
			handle_door_click(clicked_area, click_position)
			return

	handle_floor_click(click_position)

func handle_door_click(clicked_area, click_position: Vector2):
	if clicked_area.can_open_door(global_position):
		get_tree().change_scene_to_file("res://Ending/ending.tscn")
		return

	current_clicked_area = clicked_area

	nav_agent.target_position = clicked_area.approach_point.global_position
	moving = true
	clicked_on_obstacle = true

	target_arrow.global_position = click_position
	target_arrow.visible = true
	target_arrow.play("default")

func handle_table_click(clicked_area, click_position: Vector2):
	if clicked_area.can_start_minigame(global_position):
		GameState.player_return_position = global_position
		GameState.has_return_position = true
		get_tree().change_scene_to_file(clicked_area.minigame_scene_path)
		return

	current_clicked_area = clicked_area

	nav_agent.target_position = clicked_area.approach_point.global_position
	moving = true
	clicked_on_obstacle = true

	target_arrow.global_position = click_position
	target_arrow.visible = true
	target_arrow.play("default")


func handle_floor_click(click_position: Vector2):
	current_clicked_area = null

	var navigation_map = get_world_2d().navigation_map
	var closest_floor_position = NavigationServer2D.map_get_closest_point(
		navigation_map,
		click_position
	)

	clicked_on_obstacle = click_position.distance_to(closest_floor_position) > 5

	nav_agent.target_position = closest_floor_position + foot_offset
	moving = true

	target_arrow.global_position = click_position
	target_arrow.visible = true
	target_arrow.play("default")


func _physics_process(delta: float) -> void:
	if moving:
		if nav_agent.is_navigation_finished():
			stop_moving()
			return

		var next_position = nav_agent.get_next_path_position()
		var direction = global_position.direction_to(next_position)

		velocity = direction * speed
		play_walk_animation(direction)
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		idle()


func stop_moving():
	velocity = Vector2.ZERO
	moving = false
	target_arrow.visible = false

	if clicked_on_obstacle:
		look_at_point(arrow_position)

	idle()


func look_at_point(point: Vector2):
	var direction = point - global_position

	if abs(direction.x) > 8:
		if direction.x > 0:
			idle_dir = RIGHT
		else:
			idle_dir = LEFT
	else:
		if direction.y > 0:
			idle_dir = DOWN
		else:
			idle_dir = UP


func play_walk_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.play("run_right")
			idle_dir = RIGHT
		else:
			anim.play("run_left")
			idle_dir = LEFT
	else:
		if direction.y > 0:
			anim.play("run_down")
			idle_dir = DOWN
		else:
			anim.play("run_up")
			idle_dir = UP


func idle():
	match idle_dir:
		DOWN:
			anim.play("idle_down")
		UP:
			anim.play("idle_up")
		LEFT:
			anim.play("idle_left")
		RIGHT:
			anim.play("idle_right")
			
