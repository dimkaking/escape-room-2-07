extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

# Кнопки и объекты на главной сцене
@onready var next_button = $NextButton
@onready var back_button = $BackButton
@onready var exit_button = $ExitButton
@onready var student_sprite = $StudentSprite
@onready var monitor = $monitor

var code_container: VBoxContainer
var line_index := 0
var is_finishing := false
var correct_answers := {}

# --- НАЧАЛЬНЫЙ ДИАЛОГ ---
var lines := [
	"Ho-ho-ho!",
	"Da sind wir uns also endlich begegnet.",
	"Ich bin das letzte Hindernis zwischen dir und deiner Freiheit.",
	"Ich hoffe, du hast diesen einen Gegenstand gefunden, denn ohne ihn kommst du hier nicht weiter.",
	"Jetzt ist es Zeit für die finale Aufgabe.",
	"Wenn du scheiterst, bleibst du für immer in diesem Klassenzimmer!",
	"HA-HA-HA-HA!",
	"Mach dich bereit für die schwierigste Prüfung der Welt…",
	"Du musst ein Programm schreiben, das Hallo Welt! in C++ ausgibt."
]

# --- ФИНАЛЬНЫЙ ДИАЛОГ ПОСЛЕ ПОБЕДЫ ---
var finish_lines := [
	"Was?! Das ist unmöglich!",
	"Du hast es tatsächlich geschafft, den Code fehlerfrei zu schreiben...",
	"Ich muss zugeben, das war eine beeindruckende Leistung.",
	"Wie versprochen, halte ich mich an mein Wort. Du darfst gehen.",
	"Die Freiheit wartet auf dich! Viel Erfolg!"
]

func _ready() -> void:
	# Автоматически связываем сигналы кнопок с функциями
	if next_button and not next_button.pressed.is_connected(_on_next_button_pressed):
		next_button.pressed.connect(_on_next_button_pressed)
	if back_button and not back_button.pressed.is_connected(_on_back_button_pressed):
		back_button.pressed.connect(_on_back_button_pressed)
	if exit_button and not exit_button.pressed.is_connected(_on_exit_button_pressed):
		exit_button.pressed.connect(_on_exit_button_pressed)
			
	# Настройка контейнера для кода на мониторе
	if has_node("monitor/CodeContainer"):
		code_container = $monitor/CodeContainer as VBoxContainer
	elif has_node("CodeContainer"):
		code_container = $CodeContainer as VBoxContainer
	else:
		code_container = VBoxContainer.new()
		code_container.name = "CodeContainer"
		if monitor:
			monitor.add_child(code_container)
			code_container.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE)
			code_container.position = Vector2(110, 70) 

	if dialogue_box: dialogue_box.visible = true
	if student_sprite: student_sprite.visible = true
	if next_button: next_button.visible = true
	if back_button: back_button.visible = true
	if monitor: monitor.visible = false
	
	show_dialogue()

func show_dialogue() -> void:
	if name_label: name_label.text = "Dr. Barth"
	if text_label:
		if not is_finishing:
			text_label.text = lines[line_index]
		else:
			text_label.text = finish_lines[line_index]

func _on_next_button_pressed() -> void:
	if not is_finishing:
		if line_index < lines.size() - 1:
			line_index += 1
			show_dialogue()
		else:
			start_code_game()
	else:
		if line_index < finish_lines.size() - 1:
			line_index += 1
			show_dialogue()
		else:
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")

func _on_back_button_pressed() -> void:
	if line_index > 0:
		line_index -= 1
		show_dialogue()

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")

func start_code_game() -> void:
	if dialogue_box: dialogue_box.visible = false
	if monitor: monitor.visible = true
	build_code_pieces()

func build_code_pieces() -> void:
	if not code_container: return

	var children_list: Array = code_container.get_children()
	for child in children_list:
		child.queue_free()
		
	correct_answers.clear()
	var font_size = 20
	
	# Строка 1
	var row1 = HBoxContainer.new()
	row1.add_child(create_label("#", font_size))
	row1.add_child(create_input("include", font_size))
	row1.add_child(create_label(" <", font_size))
	row1.add_child(create_input("iostream", font_size))
	row1.add_child(create_label(">", font_size))
	code_container.add_child(row1)
	
	# Строка 2
	var row2 = HBoxContainer.new()
	row2.add_child(create_input("int", font_size))
	row2.add_child(create_label(" ", font_size))
	row2.add_child(create_input("main", font_size))
	row2.add_child(create_label("(){", font_size))
	code_container.add_child(row2)
	
	# Строка 3
	var row3 = HBoxContainer.new()
	row3.add_child(create_label("    ", font_size))
	row3.add_child(create_input("std", font_size))
	row3.add_child(create_label("::", font_size))
	row3.add_child(create_input("cout", font_size))
	row3.add_child(create_label(" << \"", font_size))
	row3.add_child(create_input("Hallo Welt!", font_size))
	row3.add_child(create_label("\";", font_size))
	code_container.add_child(row3)
	
	# Строка 4
	var row4 = HBoxContainer.new()
	row4.add_child(create_label("}", font_size))
	code_container.add_child(row4)
	
	var spacer = Control.new()
	spacer.custom_minimum_size.y = 12
	code_container.add_child(spacer)
	
	# Красивая и заметная кнопка проверки
	var verify_btn = Button.new()
	verify_btn.text = " Code verifizieren "
	verify_btn.add_theme_font_size_override("font_size", 18)
	verify_btn.add_theme_color_override("font_color", Color.WHITE)
	
	var btn_normal = StyleBoxFlat.new()
	btn_normal.bg_color = Color(0.05, 0.25, 0.5)
	btn_normal.border_color = Color(0.2, 0.6, 1.0)
	btn_normal.set_border_width_all(2)
	btn_normal.set_corner_radius_all(5)
	btn_normal.set_content_margin_all(8)
	
	var btn_hover = btn_normal.duplicate() as StyleBoxFlat
	btn_hover.bg_color = Color(0.1, 0.4, 0.7)
	btn_hover.border_color = Color(0.4, 0.8, 1.0)
	
	verify_btn.add_theme_stylebox_override("normal", btn_normal)
	verify_btn.add_theme_stylebox_override("hover", btn_hover)
	verify_btn.add_theme_stylebox_override("focus", btn_normal)
	
	verify_btn.pressed.connect(_check_code_answers)
	code_container.add_child(verify_btn)

# --- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ГЕНЕРАЦИИ ИНТЕРФЕЙСА ---

func create_label(text: String, size: int) -> Label:
	var lbl = Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", size)
	lbl.add_theme_color_override("font_color", Color.WHITE)
	return lbl

func create_input(correct_text: String, size: int) -> LineEdit:
	var input = LineEdit.new()
	input.add_theme_font_size_override("font_size", size)
	input.expand_to_text_length = true
	input.alignment = HORIZONTAL_ALIGNMENT_CENTER
	input.custom_minimum_size.x = correct_text.length() * 13 + 16
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.6)
	style.border_color = Color(0.2, 0.6, 1.0)
	style.set_border_width_all(2)
	style.set_content_margin_all(2)
	
	input.add_theme_stylebox_override("normal", style)
	input.add_theme_stylebox_override("focus", style)
	
	correct_answers[input] = correct_text
	return input

func _check_code_answers() -> void:
	var all_correct = true
	
	for input_node in correct_answers:
		var user_text: String = input_node.text.strip_edges()
		var right_text: String = correct_answers[input_node]
		var current_style = input_node.get_theme_stylebox("normal").duplicate() as StyleBoxFlat
		
		if user_text == right_text:
			current_style.border_color = Color(0.2, 0.9, 0.2)
		else:
			current_style.border_color = Color(1.0, 0.2, 0.2)
			all_correct = false
			
		input_node.add_theme_stylebox_override("normal", current_style)
		input_node.add_theme_stylebox_override("focus", current_style)
		
	if all_correct:
		_on_puzzle_solved()

func _on_puzzle_solved() -> void:
	if monitor: monitor.visible = false
	is_finishing = true
	line_index = 0
	if dialogue_box: dialogue_box.visible = true
	show_dialogue()
