extends Node

var normal_cursor = preload("res://UI/cat_cursor.png")
var click_cursor = preload("res://UI/cat_cursor_02.png")

func _ready():
	Input.set_custom_mouse_cursor(normal_cursor)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_custom_mouse_cursor(click_cursor)
		else:
			Input.set_custom_mouse_cursor(normal_cursor)
