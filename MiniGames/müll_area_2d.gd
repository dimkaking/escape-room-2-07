extends Area2D

var speed =300.0
var direction = 1

func _process(delta):
	position.x += speed * direction * delta

	if position.x > 1100:
		direction = -1

	if position.x < 800:
		direction = 1
