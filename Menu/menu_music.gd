extends Node2D

func play_music():
	if Audio.sound_enabled and !$menuMusic.playing:
		$menuMusic.play()

func stop_music():
	if $menuMusic.playing:
		$menuMusic.stop()
