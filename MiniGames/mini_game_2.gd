extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

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

func _ready():

	dialogue_box.visible = true

	$PapirArea2D2.visible = false
	$MüllArea2D.visible = false
	$ScoreLabel.visible = false

	show_dialogue()

func show_dialogue():

	name_label.text = "Kaha"
	text_label.text = lines[line_index]

func _on_next_button_pressed():

	if line_index < lines.size() - 1:

		line_index += 1
		show_dialogue()

	else:

		if task_finished:
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
		else:
			start_minigame()

func _on_back_button_pressed():

	if line_index > 0:

		line_index -= 1
		show_dialogue()

func start_minigame():

	dialogue_box.visible = false

	$PapirArea2D2.visible = true
	$MüllArea2D.visible = true
	$ScoreLabel.visible = true

func paper_hit():

	score += 1

	$ScoreLabel.text = "Treffer: %d/3" % score

	if score >= 3:
		win_game()

func win_game():

	task_finished = true

	$PapirArea2D2.visible = false
	$MüllArea2D.visible = false
	$ScoreLabel.visible = false

	line_index = 0
	lines = finish_lines

	dialogue_box.visible = true

	show_dialogue()
