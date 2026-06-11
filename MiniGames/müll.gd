extends Sprite2D

var speed = 0
var direction = 1

func _process(delta):
	position.x += speed * direction * delta

	if position.x > 1900:
		direction = -1

	if position.x < 1800:
		direction = 1
