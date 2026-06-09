extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func _on_spielen_pressed() -> void:
	MenuMusic.stop_music()
	GameMusic.play_music()
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")

func _on_beenden_pressed() -> void:
	get_tree().quit()
