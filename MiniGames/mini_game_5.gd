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
var finish_lines := [
	"Super!",
	"Du hast alle Rätsel richtig gelöst.",
	"Jetzt konnten wir das Tablet entsperren.",
	"Vielen Dank für deine Hilfe!",
	"Viel Erfolg auf deinem weiteren Weg!"
]
var line_index := 0
var entered_pin := ""
var correct_pin := "1205"
var task_finished := false

func _ready():

	$PuzzlePanel.visible = false
	$Tablet.visible = false

	show_dialogue()

func show_dialogue():

	name_label.text = "Lisa Fatona Alina"
	text_label.text = lines[line_index]

func _on_next_button_pressed():

	if line_index < lines.size() - 1:

		line_index += 1
		show_dialogue()

	else:

		if task_finished:

			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")

		else:

			start_puzzle()

func _on_back_button_pressed():

	if line_index > 0:

		line_index -= 1
		show_dialogue()

func start_puzzle():

	dialogue_box.visible = false

	$PuzzlePanel.visible = true
	$Tablet.visible = true

func add_digit(number):

	if entered_pin.length() < 4:

		entered_pin += str(number)

		$Tablet/PinLabel.text = "•".repeat(entered_pin.length())

func _on_button_1_pressed() -> void:
	add_digit(1)

func _on_button_2_pressed() -> void:
	add_digit(2)

func _on_button_3_pressed() -> void:
	add_digit(3)

func _on_button_4_pressed() -> void:
	add_digit(4)

func _on_button_5_pressed() -> void:
	add_digit(5)

func _on_button_6_pressed() -> void:
	add_digit(6)

func _on_button_7_pressed() -> void:
	add_digit(7)

func _on_button_8_pressed() -> void:
	add_digit(8)

func _on_button_9_pressed() -> void:
	add_digit(9)

func _on_button_0_pressed() -> void:
	add_digit(0)

func _on_clear_button_pressed() -> void:

	entered_pin = ""

	$Tablet/PinLabel.text = entered_pin

func _on_enter_button_pressed() -> void:

	if entered_pin == correct_pin:

		print("PIN richtig!")

		task_finished = true

		line_index = 0
		lines = finish_lines

		dialogue_box.visible = true
		$PuzzlePanel.visible = false
		$Tablet.visible = false

		show_dialogue()

	else:

		print("Falscher PIN!")

		entered_pin = ""

		$Tablet/PinLabel.text = entered_pin
