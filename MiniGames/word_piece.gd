extends Area2D

@export var word_text := ""
@export var correct_slot_path: NodePath

var dragging := false
var offset := Vector2.ZERO
var placed := false
var can_drag := false
var start_position := Vector2.ZERO
var drop_position := Vector2.ZERO

@onready var label = $Label


func _ready():
	label.text = word_text
	start_position = global_position


func reset_word():
	placed = false
	can_drag = true
	visible = true
	global_position = start_position
	z_index = 1


func _input_event(_viewport, event, _shape_idx):
	if placed or not can_drag:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			offset = global_position - get_global_mouse_position()
			z_index = 100
		else:
			drop_position = get_global_mouse_position()
			dragging = false
			z_index = 1
			get_tree().current_scene.try_place_word(self)


func _process(_delta):
	if dragging and not placed:
		global_position = get_global_mouse_position() + offset
		
		
func get_center_offset() -> Vector2:
	return $CollisionShape2D.position
