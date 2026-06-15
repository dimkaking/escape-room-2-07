extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

var lines := [
	"Hallo!",
	"Danke, dass du unser Tablet zurückgebracht hast!",
	"Allerdings haben wir ein Problem – wir haben das Passwort komplett vergessen.",
	"Zum Glück erinnern wir uns noch an drei Rätsel.",
	"Leider bilden ihre Antworten unseren PIN-Code.",
	"Deine Aufgabe ist es, alle Rätsel zu lösen und die Antworten in die richtige Reihenfolge zu bringen.",
	"Schaffst du das, finden wir den Code heraus und können das Tablet entsperren!"
]

var line_index := 0

func _ready():

	show_dialogue()

func show_dialogue():

	name_label.text = "Mona Fatima Ailun"
	text_label.text = lines[line_index]

func _on_next_button_pressed():

	if line_index < lines.size() - 1:

		line_index += 1
		show_dialogue()

	else:

		start_puzzle()

func _on_back_button_pressed():

	if line_index > 0:

		line_index -= 1
		show_dialogue()

func start_puzzle():

	dialogue_box.visible = false

	print("Здесь начнётся игра с загадками")
