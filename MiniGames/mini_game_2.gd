extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

@onready var paper = $PapirArea2D2
@onready var trash = $MüllArea2D
@onready var score_label = $ScoreLabel
@onready var back_button = $BackButton
@onready var exit_button = $ExitButton

var lines := [
	"Hallo!",
	"Ich möchte heute früher von der Schule weg.",
	"Aber Herr Papia hat gesagt, dass ich erst das ganze Klassenzimmer aufräumen muss.",
	"Du musst mir helfen, die Papierstücke in den Mülleimer zu werfen.",
	"Dafür gebe ich dir etwas, das dir nützlich sein könnte."
]

var finish_lines := [
	"Danke!",
	"Du hast mir wirklich geholfen.",
	"Hier, nimm das. Vielleicht wird es dir noch nützlich sein."
]

var line_index := 0
var score := 0
var task_finished := false
var task_completed_saved := false


func _ready():
	dialogue_box.visible = true
	back_button.visible = true
	exit_button.visible = true

	paper.visible = false
	trash.visible = false
	score_label.visible = false

	score_label.text = "Treffer: 0/3"

	show_dialogue()


func _input(event):
	if event.is_action_pressed("ui_accept") and dialogue_box.visible:
		next_line()


func show_dialogue():
	name_label.text = "Kaha"
	text_label.text = lines[line_index]


func next_line():
	line_index += 1

	if line_index >= lines.size():
		if task_finished:
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
		else:
			start_minigame()
	else:
		show_dialogue()


func previous_line():
	if not dialogue_box.visible:
		return

	if line_index > 0:
		line_index -= 1
		show_dialogue()


func start_minigame():
	dialogue_box.visible = false
	back_button.visible = false

	paper.visible = true
	trash.visible = true
	score_label.visible = true


func paper_hit():
	score += 1
	score_label.text = "Treffer: %d/3" % score

	if score >= 3:
		win_game()


func win_game():
	task_finished = true

	if not task_completed_saved:
		task_completed_saved = true
		GameState.complete_current_task("tisch2_paper", "puzzle_piece")

	paper.visible = false
	trash.visible = false
	score_label.visible = false

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
