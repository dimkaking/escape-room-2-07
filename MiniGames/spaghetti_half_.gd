extends Area2D

@export var side := "left" # left или right

var dragging := false
var offset := Vector2.ZERO
var can_drag := false
var used := false

@onready var end_point = $EndPoint


func set_can_drag(value: bool):
	can_drag = value


func _input_event(_viewport, event, _shape_idx):
	if used or not can_drag:
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
				try_connect()


func _process(_delta):
	if dragging and not used:
		global_position = get_global_mouse_position() + offset


func try_connect():
	var best_other = null
	var best_distance := 999999.0

	for other in get_parent().get_children():
		if other == self:
			continue

		if not other.has_method("get_end_position"):
			continue

		if other.used:
			continue

		if other.side == side:
			continue

		var distance = get_end_position().distance_to(other.get_end_position())

		if distance < best_distance:
			best_distance = distance
			best_other = other

	if best_other != null and best_distance < 80:
		get_parent().get_parent().connect_spaghetti(self, best_other)


func get_end_position() -> Vector2:
	return end_point.global_position
