extends CharacterBody2D

enum {
	DOWN,
	UP,
	LEFT,
	RIGHT
}

@onready var anim = $AnimatedSprite2D
@onready var target_arrow = $TargetArrow

@export var speed := 200.0

var target_position: Vector2
var moving := false
var idle_dir = DOWN


func _ready():
	target_position = global_position
	
	target_arrow.visible = false
	target_arrow.top_level = true
	
	if target_arrow.sprite_frames.has_animation("default"):
		target_arrow.play("default")


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			target_position = get_global_mouse_position()
			moving = true

			target_arrow.global_position = target_position
			target_arrow.visible = true
			target_arrow.play("default")


func _physics_process(delta: float) -> void:
	if moving:
		var direction = global_position.direction_to(target_position)
		velocity = direction * speed

		play_walk_animation(direction)

		if global_position.distance_to(target_position) < 5:
			velocity = Vector2.ZERO
			moving = false
			target_arrow.visible = false
			idle()
	else:
		velocity = Vector2.ZERO
		idle()

	move_and_slide()


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
