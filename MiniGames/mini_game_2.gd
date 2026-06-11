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

var line_index := 0


func _ready():
	dialogue_box.visible = true
	show_dialogue()

func show_dialogue():
	name_label.text = "Max"
	text_label.text = lines[line_index]

func _on_next_button_pressed():
	if line_index < lines.size() - 1:
		line_index += 1
		show_dialogue()
	else:
		start_minigame()

func _on_back_button_pressed():
	if line_index > 0:
		line_index -= 1
		show_dialogue()

func start_minigame():
	dialogue_box.visible = false
	

	# Здесь позже запустим мини-игру с мусоркой
	print("Mini Game Start")
