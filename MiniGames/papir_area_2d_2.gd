extends Area2D

var falling = false
var fall_speed = 500
var score = 0

var start_pos : Vector2

@onready var trash = $"../MüllArea2D"

func _ready():
	start_pos = position

func _process(delta):

	if falling:

		position.y += fall_speed * delta

		if position.y >= trash.position.y:

			if abs(position.x - trash.position.x) < 80:

				score += 1
				update_score()
				reset_paper()

			elif position.y > trash.position.y + 150:

				reset_paper()
			
func _input(event):

	if event.is_action_pressed("ui_accept") and !falling:
		falling = true

func reset_paper():

	position = start_pos
	falling = false

func update_score():

	print("Попаданий: ", score)

	if score >= 3:
		print("Победа!")
