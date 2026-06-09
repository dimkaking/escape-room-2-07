extends Node2D

var music_enabled := true

func toggle_music():
	music_enabled = !music_enabled

	if music_enabled:
		$menuMusic.play()
	else:
		$menuMusic.stop()
		

func play_music():
	$menuMusic.play()

func stop_music():
	$menuMusic.stop()
