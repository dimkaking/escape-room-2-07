extends Area2D

@export var word_text := ""

var dragging := false
var offset := Vector2.ZERO
var placed := false

@onready var label = $Label


func _ready():
	label.text = word_text


func _input_event(_viewport, event, _shape_idx):
	if placed:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				offset = global_position - get_global_mouse_position()
				z_index = 100
			else:
				dragging = false
				z_index = 1
				get_tree().current_scene.try_place_word(self)


func _process(_delta):
	if dragging and not placed:
		global_position = get_global_mouse_position() + offset
