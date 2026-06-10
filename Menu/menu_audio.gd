extends Node2D

func _ready() -> void:
	update_icon()

func _on_audio_pressed() -> void:
	Audio.toggle_sound()
	update_icon()

	if Audio.sound_enabled:
		MenuMusic.play_music()
	else:
		MenuMusic.stop_music()

func update_icon() -> void:
	if Audio.sound_enabled:
		$audio.text = "🔊"
	else:
		$audio.text = "🔇"

func _on_zuruck_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/setting.tscn")
