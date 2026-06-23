extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

@onready var next_button = $DialogueBox/NextButton
@onready var back_button = $DialogueBox/BackButton
@onready var exit_button = $DialogueBox/ExitButton

@onready var student_sprite = $StudentSprite
@onready var monitor = $monitor
@onready var code_container = $monitor/CodeContainer

var line_index := 0
var task_finished := false
var task_completed_saved := false

var correct_answers := {}

var lines := [
	"Ho-ho-ho!",
	"Da sind wir uns also endlich begegnet.",
	"Ich bin das letzte Hindernis zwischen dir und deiner Freiheit.",
	"Ich hoffe, du hast diesen einen Gegenstand gefunden, denn ohne ihn kommst du hier nicht weiter.",
	"Jetzt ist es Zeit für die finale Aufgabe.",
	"Du musst ein Programm schreiben, das Hallo Welt! in C++ ausgibt."
]

var finish_lines := [
	"Was?! Das ist unmöglich!",
	"Du hast es tatsächlich geschafft, den Code fehlerfrei zu schreiben...",
	"Wie versprochen, halte ich mich an mein Wort.",
	"Die Freiheit wartet auf dich!"
]


func _ready() -> void:
	dialogue_box.visible = true
	monitor.visible = false
	show_dialogue()


func _input(event):
	if event.is_action_pressed("ui_accept") and dialogue_box.visible:
		next_line()


func show_dialogue():
	name_label.text = "Dr. Borat"
	text_label.text = lines[line_index]


func next_line():
	line_index += 1

	if line_index >= lines.size():
		if task_finished:
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
		else:
			start_code_game()
	else:
		show_dialogue()


func previous_line():
	if not dialogue_box.visible:
		return

	if line_index > 0:
		line_index -= 1
		show_dialogue()


func start_code_game():
	dialogue_box.visible = false
	back_button.visible = false
	monitor.visible = true
	build_code_pieces()


func build_code_pieces():
	for child in code_container.get_children():
		child.queue_free()

	correct_answers.clear()

	var font_size := 32

	var row1 = HBoxContainer.new()
	row1.add_child(create_label("#", font_size))
	row1.add_child(create_input("include", font_size, 15))
	row1.add_child(create_label(" <", font_size))
	row1.add_child(create_input("iostream", font_size, 150))
	row1.add_child(create_label(">", font_size))
	code_container.add_child(row1)

	var row2 = HBoxContainer.new()
	row2.add_child(create_input("int", font_size, 80))
	row2.add_child(create_label(" ", font_size))
	row2.add_child(create_input("main", font_size, 105))
	row2.add_child(create_label("(){", font_size))
	code_container.add_child(row2)

	var row3 = HBoxContainer.new()
	row3.add_child(create_label("    ", font_size))
	row3.add_child(create_input("std", font_size, 85))
	row3.add_child(create_label("::", font_size))
	row3.add_child(create_input("cout", font_size, 105))
	row3.add_child(create_label(" << \"", font_size))
	row3.add_child(create_input("Hallo Welt!", font_size, 200))
	row3.add_child(create_label("\";", font_size))
	code_container.add_child(row3)

	var row4 = HBoxContainer.new()
	row4.add_child(create_label("}", font_size))
	code_container.add_child(row4)

	var spacer = Control.new()
	spacer.custom_minimum_size.y = 20
	code_container.add_child(spacer)

	var verify_btn = Button.new()
	verify_btn.text = "Code prüfen"
	verify_btn.add_theme_font_size_override("font_size", 28)
	verify_btn.custom_minimum_size = Vector2(500, 55)
	verify_btn.pressed.connect(_check_code_answers)
	code_container.add_child(verify_btn)


func create_label(text: String, size: int) -> Label:
	var lbl = Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", size)
	lbl.add_theme_color_override("font_color", Color.WHITE)
	return lbl


func create_input(correct_text: String, size: int, width: int) -> LineEdit:
	var input = LineEdit.new()

	input.add_theme_font_size_override("font_size", size)
	input.custom_minimum_size = Vector2(width, 45)
	input.alignment = HORIZONTAL_ALIGNMENT_CENTER
	input.expand_to_text_length = false

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.65)
	style.border_color = Color(0.2, 0.6, 1.0)
	style.set_border_width_all(2)
	style.set_content_margin_all(4)

	input.add_theme_stylebox_override("normal", style)
	input.add_theme_stylebox_override("focus", style)

	correct_answers[input] = correct_text
	return input


func normalize_answer(text: String) -> String:
	return text.strip_edges().to_lower()


func is_answer_correct(user_text: String, right_text: String) -> bool:
	var user := normalize_answer(user_text)
	var right := normalize_answer(right_text)

	if right == "hallo welt!":
		return user == "hallo welt!" or user == "hallo welt"

	return user == right


func _check_code_answers():
	var all_correct := true

	for input_node in correct_answers:
		var user_text = input_node.text
		var right_text = correct_answers[input_node]

		var style = input_node.get_theme_stylebox("normal").duplicate() as StyleBoxFlat

		if is_answer_correct(user_text, right_text):
			style.border_color = Color(0.2, 0.9, 0.2)
		else:
			style.border_color = Color(1.0, 0.2, 0.2)
			all_correct = false

		input_node.add_theme_stylebox_override("normal", style)
		input_node.add_theme_stylebox_override("focus", style)

	if all_correct:
		win_game()


func win_game():
	task_finished = true

	if not task_completed_saved:
		task_completed_saved = true
		GameState.complete_current_task("tisch9_code", "door_key")

	monitor.visible = false

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
