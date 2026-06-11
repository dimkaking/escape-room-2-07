extends Node

var inventory := []
var completed_tasks := {}

var current_task := 1
var player_return_position := Vector2.ZERO
var has_return_position := false


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


func complete_current_task(task_name: String):
	if not is_task_completed(task_name):
		complete_task(task_name)
		current_task += 1
