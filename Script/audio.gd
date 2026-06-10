extends Node

var sound_enabled := true

func toggle_sound():
	set_sound_enabled(!sound_enabled)

func set_sound_enabled(value: bool):
	sound_enabled = value
	
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus, !sound_enabled)
