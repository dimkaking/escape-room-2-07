extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

@onready var puzzle_panel = $PuzzlePanel
@onready var tablet = $Tablet
@onready var pin_label = $Tablet/PinLabel

@onready var back_button = $BackButton
@onready var exit_button = $ExitButton

@onready var student_sprite_3 = $StudentSprite
@onready var student_sprite_2 = $StudentSprite2
@onready var student_sprite_1 = $StudentSprite3

var speakers := [
	"Lisa",
	"Fatona",
	"Alina",
	"Lisa",
	"Fatona",
	"Alina",
	"Lisa"
]

var lines := [
	"Hallo!",
	"Danke, dass du unser Tablet zurückgebracht hast!",
	"Allerdings haben wir ein Problem – wir haben das Passwort komplett vergessen.",
	"Zum Glück erinnern wir uns noch an drei Rätsel.",
	"Leider bilden ihre Antworten unseren PIN-Code.",
	"Deine Aufgabe ist es, alle Rätsel zu lösen und die Antworten in die richtige Reihenfolge zu bringen.",
	"Schaffst du das, finden wir den Code heraus und können das Tablet entsperren!"
]

var finish_speakers := [
	"Lisa",
	"Fatona",
	"Alina",
	"Lisa",
	"Fatona"
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
var task_completed_saved := false


func _ready():
	dialogue_box.visible = true
	back_button.visible = true
	exit_button.visible = true

	puzzle_panel.visible = false
	tablet.visible = false

	pin_label.text = ""

	show_dialogue()


func _input(event):
	if event.is_action_pressed("ui_accept") and dialogue_box.visible:
		next_line()


func show_dialogue():
	name_label.text = speakers[line_index]
	text_label.text = lines[line_index]
	update_speaker_visual()


func update_speaker_visual():
	student_sprite_1.modulate = Color(0.55, 0.55, 0.55, 1)
	student_sprite_2.modulate = Color(0.55, 0.55, 0.55, 1)
	student_sprite_3.modulate = Color(0.55, 0.55, 0.55, 1)

	match speakers[line_index]:
		"Lisa":
			student_sprite_1.modulate = Color(1, 1, 1, 1)
		"Fatona":
			student_sprite_2.modulate = Color(1, 1, 1, 1)
		"Alina":
			student_sprite_3.modulate = Color(1, 1, 1, 1)


func show_all_students():
	student_sprite_1.modulate = Color(1, 1, 1, 1)
	student_sprite_2.modulate = Color(1, 1, 1, 1)
	student_sprite_3.modulate = Color(1, 1, 1, 1)


func next_line():
	line_index += 1

	if line_index >= lines.size():
		if task_finished:
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
		else:
			start_puzzle()
	else:
		show_dialogue()


func previous_line():
	if not dialogue_box.visible:
		return

	if line_index > 0:
		line_index -= 1
		show_dialogue()


func start_puzzle():
	dialogue_box.visible = false
	back_button.visible = false

	puzzle_panel.visible = true
	tablet.visible = true

	show_all_students()

	entered_pin = ""
	pin_label.text = ""


func add_digit(number):
	if entered_pin.length() < 4:
		entered_pin += str(number)
		pin_label.text = "•".repeat(entered_pin.length())


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
	pin_label.text = ""


func _on_enter_button_pressed() -> void:
	if entered_pin == correct_pin:
		win_game()
	else:
		print("Falscher PIN!")
		entered_pin = ""
		pin_label.text = ""


func win_game():
	task_finished = true

	if not task_completed_saved:
		task_completed_saved = true
		GameState.complete_current_task("tisch5_tablet", "geodreieck")

	speakers = finish_speakers
	lines = finish_lines
	line_index = 0

	dialogue_box.visible = true
	back_button.visible = true

	puzzle_panel.visible = false
	tablet.visible = false

	show_dialogue()


func _on_next_button_pressed():
	if dialogue_box.visible:
		next_line()


func _on_back_button_pressed():
	previous_line()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
