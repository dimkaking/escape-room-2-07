extends Area2D

@export var task_number := 1

@onready var glow = $"../GlowSprite"

var player_inside := false


func _ready():
	glow.visible = false

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(_delta):
	if player_inside:
		glow.visible = GameState.can_start_task(task_number)


func _on_body_entered(body):
	if body.name == "Player":
		print("Entered highlight ", get_parent().name, " task=", task_number, " current=", GameState.current_task)
		player_inside = true
		glow.visible = GameState.can_start_task(task_number)


func _on_body_exited(body):
	if body.name == "Player":
		player_inside = false
		glow.visible = false
		
