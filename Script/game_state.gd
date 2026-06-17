extends Node

var inventory := []
var completed_tasks := {}

var current_task := 1

var player_return_position := Vector2.ZERO
var has_return_position := false

var pending_drop_item := ""
var pending_drop_texture: Texture2D = null
var picked_items := {}


func add_item(item_name: String):
	if not inventory.has(item_name):
		inventory.append(item_name)


func has_item(item_name: String) -> bool:
	return inventory.has(item_name)


func complete_task(task_name: String):
	completed_tasks[task_name] = true


func is_task_completed(task_name: String) -> bool:
	return completed_tasks.get(task_name, false)


func can_start_task(task_number: int) -> bool:
	return current_task == task_number


func complete_current_task(task_name: String, drop_item_name: String):
	if not is_task_completed(task_name):
		complete_task(task_name)
		pending_drop_item = drop_item_name


func pick_item(item_name: String):
	add_item(item_name)
	picked_items[item_name] = true
	pending_drop_item = ""

	current_task += 1


func is_item_picked(item_name: String) -> bool:
	return picked_items.get(item_name, false)
