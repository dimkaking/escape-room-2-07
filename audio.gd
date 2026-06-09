extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_zuruck_pressed() -> void:
	get_tree().change_scene_to_file("res://setting.tscn")


func _on_audio_pressed() -> void:
	sound_enabled = !sound_enabled
	
var sound_enabled = true

AudioServer.set_bus_mute(0, !sound_enabled)

if sound_enabled:
$audio.text = "🔊"
else:
$audio.text = "🔇"
