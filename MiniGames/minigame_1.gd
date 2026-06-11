extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

@onready var task_panel = $TaskPanel
@onready var ip_label = $TaskPanel/IpLabel
@onready var mask_input = $TaskPanel/MaskInput
@onready var first_input = $TaskPanel/FirstInput
@onready var last_input = $TaskPanel/LastInput
@onready var broadcast_input = $TaskPanel/BroadcastInput

@onready var student_sprite_1 = $StudentSprite
@onready var student_sprite_2 = $StudentSprite2

var speakers := [
	"Tacos",
	"Buritos",
	"Tacos",
	"Buritos"
]

var lines := [
	"Hey!",
	"Wir haben gehört, dass du unser Klassenzimmer verlassen möchtest.",
	"Wir können dir dabei helfen, aber dafür brauchen wir etwas von dir.",
	"Deine Aufgabe ist es, uns dabei zu helfen, eine IP-Adresse ausfindig zu machen."
]

var line_index := 0
var task_finished := false


func _ready():
	task_panel.visible = false
	dialogue_box.visible = true
	ip_label.text = "IP-Adresse: 192.168.178.31  /24"
	show_dialogue()


func _input(event):
	if event.is_action_pressed("ui_accept") and dialogue_box.visible:
		next_line()


func show_dialogue():
	name_label.text = speakers[line_index]
	text_label.text = lines[line_index]
	update_speaker_visual()


func next_line():
	line_index += 1

	if line_index >= lines.size():
		if task_finished:
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
		else:
			dialogue_box.visible = false
			show_task()
	else:
		show_dialogue()


func show_task():
	task_panel.visible = true
	show_both_students()
	mask_input.text = ""
	first_input.text = ""
	last_input.text = ""
	broadcast_input.text = ""


func update_speaker_visual():
	if speakers[line_index] == "Tacos":
		student_sprite_1.modulate = Color(1, 1, 1, 1)
		student_sprite_2.modulate = Color(0.55, 0.55, 0.55, 1)
	else:
		student_sprite_1.modulate = Color(0.55, 0.55, 0.55, 1)
		student_sprite_2.modulate = Color(1, 1, 1, 1)


func _on_next_button_pressed():
	if dialogue_box.visible:
		next_line()


func _on_check_button_pressed():
	var correct := true

	if mask_input.text.strip_edges() != "255.255.255.0":
		correct = false

	if first_input.text.strip_edges() != "192.168.178.1":
		correct = false

	if last_input.text.strip_edges() != "192.168.178.254":
		correct = false

	if broadcast_input.text.strip_edges() != "192.168.178.255":
		correct = false

	if correct:
		GameState.complete_current_task("tisch1_ip")
		task_finished = true
		task_panel.visible = false
		dialogue_box.visible = true

		speakers = [
			"Tacos",
			"Buritos",
			"Tacos",
			"Buritos"
		]

		lines = [
			"Sehr gut! Das ist richtig.",
			"Du hast uns wirklich geholfen.",
			"Hier, nimm diesen Stift.",
			"Vielleicht brauchst du ihn noch bei jemand anderem."
		]

		line_index = 0
		show_dialogue()
	else:
		ip_label.text = "IP-Adresse: 192.168.178.31  /24 \nLeider falsch. Versuch es noch einmal."


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
	
func show_both_students():
	student_sprite_1.modulate = Color(1, 1, 1, 1)
	student_sprite_2.modulate = Color(1, 1, 1, 1)
