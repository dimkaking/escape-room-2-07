extends Node2D

func _on_spielen_pressed() -> void:

	MenuMusic.stop_music()
	GameMusic.play_music()
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")

func _on_setting_pressed() -> void:


	get_tree().change_scene_to_file("res://Menu/setting.tscn")
