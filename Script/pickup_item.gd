extends Area2D

@export var item_name := ""

var can_pick_up := false

func _ready():
	body_entered.connect(_on_body_entered)

	play_drop_animation()


func play_drop_animation():
	var final_position = global_position

	global_position.y -= 45
	scale = Vector2.ZERO

	var tween = create_tween()
	tween.tween_property(self, "global_position", final_position, 0.35)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.35)

	await tween.finished

	can_pick_up = true


func _on_body_entered(body):
	if not can_pick_up:
		return

	if body.name == "Player":
		GameState.pick_item(item_name)
		queue_free()
