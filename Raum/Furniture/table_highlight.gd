extends Area2D

@onready var glow_sprite = get_parent().get_node_or_null("GlowSprite")


func _ready():
	if glow_sprite == null:
		print("ОШИБКА: у стола ", get_parent().name, " нет GlowSprite")
		return
	
	glow_sprite.visible = false
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if body.name == "Player" and glow_sprite != null:
		glow_sprite.visible = true


func _on_body_exited(body):
	if body.name == "Player" and glow_sprite != null:
		glow_sprite.visible = false
