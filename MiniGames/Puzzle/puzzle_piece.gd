extends Area2D

@export var correct_slot_path: NodePath
@export var snap_distance := 40.0

static var active_piece = null
static var top_z := 10

var dragging := false
var offset := Vector2.ZERO
var locked := false
var can_drag := false


func _ready():
	z_index = 1


func _input_event(_viewport, event, _shape_idx):
	if locked or not can_drag:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if active_piece != null:
					return

				active_piece = self
				dragging = true
				offset = global_position - get_global_mouse_position()

				top_z += 1
				z_index = top_z

			else:
				if active_piece != self:
					return

				dragging = false
				active_piece = null
				try_snap()


func _process(_delta):
	if dragging and not locked:
		global_position = get_global_mouse_position() + offset


func try_snap():
	var slot = get_node_or_null(correct_slot_path)

	if slot == null:
		return

	var distance = global_position.distance_to(slot.global_position)

	if distance <= snap_distance:
		global_position = slot.global_position
		locked = true
		z_index = 0
		check_puzzle_finished()


func check_puzzle_finished():
	var pieces_node = get_parent()

	for piece in pieces_node.get_children():
		if piece.has_method("is_locked"):
			if not piece.is_locked():
				return

	get_tree().current_scene.puzzle_completed()


func is_locked() -> bool:
	return locked
