extends Node

var inventory := []
var completed_tasks := {}

func add_item(item_name: String):
	if not inventory.has(item_name):
		inventory.append(item_name)

func has_item(item_name: String) -> bool:
	return inventory.has(item_name)

func complete_task(task_name: String):
	completed_tasks[task_name] = true

func is_task_completed(task_name: String) -> bool:
	return completed_tasks.get(task_name, false)
