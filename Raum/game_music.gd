extends Node2D

@onready var music = $gameMusic

func play_music():
	if Audio.sound_enabled and !music.playing:
		music.play()

func stop_music():
	if music.playing:
		music.stop()
