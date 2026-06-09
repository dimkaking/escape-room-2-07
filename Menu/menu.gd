extends Node2D


func _ready():
	MenuMusic.play_music()


func _on_setting_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/setting.tscn")
