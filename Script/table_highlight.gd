extends Area2D

@onready var glow = $"../GlowSprite"

func _ready():
	glow.visible = false

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		glow.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		glow.visible = false
