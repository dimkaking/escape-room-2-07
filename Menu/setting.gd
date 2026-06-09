extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sprache_pressed() -> void:
	get_tree().change_scene_to_file("res://sprache.tscn")


func _on_audio_pressed() -> void:
	get_tree().change_scene_to_file("res://audio.tscn") # Replace with function body.


func _on_zuruck_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn") # Replace with function body.
