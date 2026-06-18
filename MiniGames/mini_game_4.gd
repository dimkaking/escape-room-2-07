extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel
@onready var spaghetti_area = $SpaghettiArea
@onready var plate_point = $PlatePoint
@onready var back_button = $BackButton

@onready var student_sprite_1 = $StudentSprite
@onready var student_sprite_2 = $StudentSprite2

@export var full_spaghetti_texture: Texture2D

var speakers := [
	"Fisch",
	"Bartolomeo",
	"Fisch",
	"Bartolomeo",
	"Fisch"
]

var lines := [
	"Hey!",
	"Heute ist uns eine Katastrophe passiert.",
	"Als wir auf dem Weg zum Klassenzimmer waren, sind wir die Treppe heruntergefallen und haben unsere ganzen Spaghetti zerbrochen.",
	"Wir kommen aus Italien – für uns sind kaputte Spaghetti einfach keine Option!",
	"Wir haben riesigen Hunger. Hilf uns, die Spaghetti wieder zusammenzukleben, und wir helfen dir dabei, aus dem Klassenzimmer zu entkommen."
]

var line_index := 0
var completed_spaghetti := 0
var task_finished := false
var task_completed_saved := false

const REQUIRED_SPAGHETTI := 6


func _ready():
	back_button.visible = true
	set_spaghetti_enabled(false)
	dialogue_box.visible = true
	show_dialogue()


func _input(event):
	if event.is_action_pressed("ui_accept") and dialogue_box.visible:
		next_line()


func show_dialogue():
	name_label.text = speakers[line_index]
	text_label.text = lines[line_index]
	update_speaker_visual()


func update_speaker_visual():
	if speakers[line_index] == "Fisch":
		student_sprite_1.modulate = Color(1, 1, 1, 1)
		student_sprite_2.modulate = Color(0.55, 0.55, 0.55, 1)
	else:
		student_sprite_1.modulate = Color(0.55, 0.55, 0.55, 1)
		student_sprite_2.modulate = Color(1, 1, 1, 1)


func show_both_students():
	student_sprite_1.modulate = Color(1, 1, 1, 1)
	student_sprite_2.modulate = Color(1, 1, 1, 1)


func next_line():
	line_index += 1

	if line_index >= lines.size():
		if task_finished:
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
		else:
			dialogue_box.visible = false
			back_button.visible = false
			show_both_students()
			set_spaghetti_enabled(true)
	else:
		show_dialogue()


func previous_line():
	if not dialogue_box.visible:
		return

	if line_index > 0:
		line_index -= 1
		show_dialogue()


func set_spaghetti_enabled(value: bool):
	for half in spaghetti_area.get_children():
		if half.has_method("set_can_drag"):
			half.set_can_drag(value)


func connect_spaghetti(a, b):
	a.used = true
	b.used = true

	var spawn_pos = (a.global_position + b.global_position) / 2.0

	a.visible = false
	b.visible = false

	var full = Sprite2D.new()
	full.texture = full_spaghetti_texture
	full.global_position = spawn_pos
	full.scale = Vector2.ONE
	full.z_index = 50
	full.rotation_degrees = randf_range(0, 360)

	add_child(full)

	completed_spaghetti += 1
	print("Spaghetti fertig: ", completed_spaghetti, "/", REQUIRED_SPAGHETTI)

	var target_pos = plate_point.global_position + Vector2(
		randi_range(-20, 20),
		randi_range(-12, 12)
	)

	var tween = create_tween()
	tween.tween_property(full, "global_position", target_pos, 0.4)
	tween.parallel().tween_property(full, "scale", Vector2(0.2, 0.2), 0.4)

	if completed_spaghetti >= REQUIRED_SPAGHETTI:
		set_spaghetti_enabled(false)
		tween.finished.connect(finish_minigame)


func finish_minigame():
	if task_completed_saved:
		return

	task_completed_saved = true
	task_finished = true

	GameState.complete_current_task("tisch4_spaghetti", "tablet")

	dialogue_box.visible = true
	back_button.visible = true

	speakers = [
		"Bartolomeo",
		"Fisch"
	]

	lines = [
		"Perfetto! Du hast unsere Spaghetti gerettet!",
		"Jetzt helfen wir dir beim nächsten Schritt."
	]

	line_index = 0
	show_dialogue()


func _on_next_button_pressed():
	if dialogue_box.visible:
		next_line()


func _on_back_button_pressed():
	previous_line()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
