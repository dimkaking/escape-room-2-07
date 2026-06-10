extends Node

@onready var player = $AudioStreamPlayer

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if Audio.sound_enabled:
			player.stop()
			player.play()
