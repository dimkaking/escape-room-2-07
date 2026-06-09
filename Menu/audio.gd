extends Node2D

func _ready() -> void:
	update_icon()

func _on_audio_pressed() -> void:
	MenuMusic.toggle_music()
	update_icon()

func update_icon() -> void:
	if MenuMusic.music_enabled:
		$audio.text = "🔊"
	else:
		$audio.text = "🔇"


func _on_zuruck_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/setting.tscn") 
