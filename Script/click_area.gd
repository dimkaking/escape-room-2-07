extends Area2D

@onready var approach_point = $"../ApproachPoint"

var player_near := false
var paw_cursor = preload("res://UI/cat_mouse.png")


func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func set_player_near(value: bool):
	player_near = value
	
	if not player_near:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_mouse_entered():
	if player_near:
		Input.set_custom_mouse_cursor(paw_cursor)


func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
