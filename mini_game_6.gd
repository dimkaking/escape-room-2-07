extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

@onready var answer_input = $LineEdit
@onready var task_image = $aufgabe
@onready var check_button = $prüfen
@onready var antwort_label = $antwort

@onready var back_button = $BackButton
@onready var exit_button = $ExitButton

var lines := [
	"Hallo!",
	"In letzter Zeit gibt uns Herr Bruno so viele Hausaufgaben, dass ich kaum noch hinterherkomme.",
	"Mir fehlt einfach die Zeit, deshalb brauche ich deine Hilfe.",
	"Es gibt eine Aufgabe, die ich einfach nicht verstehe.",
	"Löse sie für mich, und ich werde versuchen, dir dabei zu helfen, aus dem Klassenzimmer zu entkommen."
]

var finish_lines := [
	"Super!",
	"Du hast das Rätsel richtig gelöst!",
	"Jetzt verstehe ich die Aufgabe endlich.",
	"Vielen Dank für deine Hilfe!",
	"Ich helfe dir jetzt beim nächsten Schritt."
]

var line_index := 0
var correct_answer := "100"

var task_finished := false
var task_completed_saved := false


func _ready():
	dialogue_box.visible = true
	back_button.visible = true
	exit_button.visible = true

	answer_input.visible = false
	task_image.visible = false
	check_button.visible = false
	antwort_label.visible = false

	show_dialogue()


func _input(event):
	if event.is_action_pressed("ui_accept") and dialogue_box.visible:
		next_line()


func show_dialogue():
	name_label.text = "Lumi"
	text_label.text = lines[line_index]


func next_line():
	line_index += 1

	if line_index >= lines.size():
		if task_finished:
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
		else:
			start_task()
	else:
		show_dialogue()


func previous_line():
	if not dialogue_box.visible:
		return

	if line_index > 0:
		line_index -= 1
		show_dialogue()


func start_task():
	dialogue_box.visible = false
	back_button.visible = false

	answer_input.visible = true
	answer_input.text = ""

	task_image.visible = true
	check_button.visible = true

	antwort_label.visible = true
	antwort_label.text = "Bitte gib deine Antwort ein:"


func _on_prüfen_pressed() -> void:
	var player_answer = answer_input.text.strip_edges()

	if player_answer == correct_answer:
		win_game()
	else:
		answer_input.text = ""
		antwort_label.text = "Deine Antwort ist falsch. Versuch es noch einmal!"


func win_game():
	task_finished = true

	if not task_completed_saved:
		task_completed_saved = true
		GameState.complete_current_task("tisch6_angle")

	answer_input.visible = false
	task_image.visible = false
	check_button.visible = false
	antwort_label.visible = false

	lines = finish_lines
	line_index = 0

	dialogue_box.visible = true
	back_button.visible = true

	show_dialogue()


func _on_next_button_pressed():
	if dialogue_box.visible:
		next_line()


func _on_back_button_pressed():
	previous_line()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
