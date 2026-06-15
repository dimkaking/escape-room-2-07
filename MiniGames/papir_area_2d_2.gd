extends Area2D

var falling = false
var fall_speed = 500
var score = 0
var task_finished = false
var start_pos : Vector2

@onready var trash = $"../MüllArea2D"

func _ready():
	start_pos = position

func _process(delta):

	if falling:

		position.y += fall_speed * delta

		if position.y >= trash.position.y - 20 and position.y <= trash.position.y + 20:

			if abs(position.x - trash.position.x) < 60:

				get_parent().paper_hit()

				reset_paper()

		elif position.y > trash.position.y + 150:

			reset_paper()

func _input(event):

	if event.is_action_pressed("ui_accept") and !falling:
		falling = true

func reset_paper():

	position = start_pos
	falling = false
