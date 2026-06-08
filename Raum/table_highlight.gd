extends Area2D

@onready var glow_sprite = $"../GlowSprite"

func _ready():
	glow_sprite.visible = false
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		glow_sprite.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		glow_sprite.visible = false
