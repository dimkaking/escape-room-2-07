extends Sprite2D

var falling = false
var fall_speed = 500

func _process(delta):

	if falling:
		position.y += fall_speed * delta

func _input(event):

	if event.is_action_pressed("ui_accept") and !falling:
		falling = true
