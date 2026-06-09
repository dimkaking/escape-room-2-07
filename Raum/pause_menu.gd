extends CanvasLayer

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_audio_button()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	update_audio_button()


func _on_fortsetzen_pressed():
	get_tree().paused = false
	visible = false


func _on_audio_pressed():
	Audio.toggle_sound()
	update_audio_button()


func update_audio_button():
	if Audio.sound_enabled:
		$Panel/Audio.text = "🔊"
	else:
		$Panel/Audio.text = "🔇"


func _on_hauptmenü_pressed() -> void:
	get_tree().paused = false
	GameMusic.stop_music()
	MenuMusic.play_music()
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
