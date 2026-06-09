extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_zuruck_pressed() -> void:
	get_tree().change_scene_to_file("res://setting.tscn")


#func _on_audio_pressed() -> void:
var music_enabled := true

func _ready():
		pass

func _on_audio_pressed():
	music_enabled = !music_enabled

	if music_enabled:
		menuMusic.play()
	else:
		menuMusic.stop()

	update_icon()

func update_icon():
	if music_enabled:
		$Button.text = "🔊"
	else:
		$Button.text = "🔇"
