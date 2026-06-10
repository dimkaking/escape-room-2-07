extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel
@onready var next_button = $DialogueBox/NextButton

@onready var task_panel = $TaskPanel
@onready var question_label = $TaskPanel/QuestionLabel
@onready var answer_input = $TaskPanel/AnswerInput
@onready var check_button = $TaskPanel/CheckButton

@onready var student_sprite_1 = $StudentSprite
@onready var student_sprite_2 = $StudentSprite2

var speakers := [
	"Schüler 1",
	"Schüler 2",
	"Schüler 1",
	"Schüler 2"
]

var lines := [
	"Hey!",
	"Wir haben gehört, dass du unser Klassenzimmer verlassen möchtest.",
	"Wir können dir dabei helfen, aber dafür brauchen wir etwas von dir.",
	"Deine Aufgabe ist es, uns dabei zu helfen, eine IP-Adresse ausfindig zu machen."
]

var line_index := 0
var correct_answer := "192.168.0.1"


func _ready():
	task_panel.visible = false
	dialogue_box.visible = true
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
		dialogue_box.visible = false
		show_task()
	else:
		show_dialogue()


func show_task():
	task_panel.visible = true
	question_label.text = "Welche IP-Adresse hast du gefunden?"
	answer_input.text = ""


func update_speaker_visual():
	if speakers[line_index] == "Schüler 1":
		student_sprite_1.modulate = Color(1, 1, 1, 1)
		student_sprite_2.modulate = Color(0.55, 0.55, 0.55, 1)
	else:
		student_sprite_1.modulate = Color(0.55, 0.55, 0.55, 1)
		student_sprite_2.modulate = Color(1, 1, 1, 1)


func _on_next_button_pressed():
	if dialogue_box.visible:
		next_line()


func _on_check_button_pressed():
	if answer_input.text.strip_edges() == correct_answer:
		task_panel.visible = false
		dialogue_box.visible = true

		speakers = ["Schüler 1", "Schüler 2"]
		lines = [
			"Sehr gut! Das ist die richtige IP-Adresse.",
			"Danke für deine Hilfe. Dafür bekommst du gleich einen Gegenstand."
		]

		line_index = 0
		show_dialogue()
	else:
		question_label.text = "Das ist leider falsch. Versuch es noch einmal."


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
