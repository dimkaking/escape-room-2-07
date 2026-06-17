extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

@onready var sentence_panel = $SentencePanel
@onready var answer_box = $SentencePanel/AnswerBox
@onready var word_buttons = $SentencePanel/WordButtons
@onready var error_label = $SentencePanel/ErrorLabel

@onready var back_button = $BackButton
@onready var exit_button = $ExitButton
@onready var student_sprite = $StudentSprite

var lines := [
	"Hallo!",
	"Irgendwie habe ich ein Talent dafür, ständig Ärger zu bekommen.",
	"Das Problem ist, dass ich im Unterricht die ganze Zeit rede.",
	"Selbst wenn ich versuche, ruhig zu bleiben, fange ich nach ein paar Minuten wieder an zu quatschen.",
	"Die Lehrer sind es schon leid, mir ständig Ermahnungen zu geben.",
	"Hilf mir, einen Eintrag ins Klassenbuch zu bekommen, und ich helfe dir dabei, aus unserem Klassenzimmer zu entkommen."
]

var finish_lines := [
	"Perfekt!",
	"Endlich habe ich meinen Eintrag ins Klassenbuch bekommen.",
	"Vielleicht höre ich jetzt endlich auf, im Unterricht die ganze Zeit zu reden.",
	"Danke für deine Hilfe!"
]

var line_index := 0
var task_finished := false
var task_completed_saved := false


func _ready():
	error_label.visible = false
	dialogue_box.visible = true
	sentence_panel.visible = false
	back_button.visible = true
	exit_button.visible = true

	show_dialogue()


func _input(event):
	if event.is_action_pressed("ui_accept") and dialogue_box.visible:
		next_line()


func show_dialogue():
	name_label.text = "Pau"
	text_label.text = lines[line_index]
	student_sprite.modulate = Color(1, 1, 1, 1)


func next_line():
	line_index += 1

	if line_index >= lines.size():
		if task_finished:
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
		else:
			start_sentence_game()
	else:
		show_dialogue()


func previous_line():
	if not dialogue_box.visible:
		return

	if line_index > 0:
		line_index -= 1
		show_dialogue()


func start_sentence_game():
	dialogue_box.visible = false
	back_button.visible = false
	sentence_panel.visible = true

	for slot in answer_box.get_children():
		slot.visible = true

	for word in word_buttons.get_children():
		if word.has_method("reset_word"):
			word.reset_word()


func try_place_word(word_piece):
	var slot = word_piece.get_node_or_null(word_piece.correct_slot_path)

	if slot == null:
		word_piece.global_position = word_piece.start_position
		return

	var slot_rect = slot.get_global_rect()
	slot_rect = slot_rect.grow(25)

	if slot_rect.has_point(word_piece.drop_position):
		word_piece.global_position = slot.get_global_rect().get_center() - word_piece.get_center_offset()
		word_piece.placed = true
		word_piece.can_drag = false
		slot.visible = false
	else:
		word_piece.global_position = word_piece.start_position

func check_sentence_finished():
	for word in word_buttons.get_children():
		if not word.placed:
			return

	win_game()


func win_game():
	task_finished = true

	if not task_completed_saved:
		task_completed_saved = true
		GameState.complete_current_task("tisch7_klassenbuch")

	lines = finish_lines
	line_index = 0

	dialogue_box.visible = true
	back_button.visible = true
	sentence_panel.visible = false

	show_dialogue()


func show_error():
	error_label.visible = true
	error_label.text = "Du musst den Eintrag zuerst fertigstellen!"

	await get_tree().create_timer(2.0).timeout

	error_label.visible = false

func all_words_placed() -> bool:
	for word in word_buttons.get_children():
		if not word.placed:
			return false

	return true

func _on_next_button_pressed():
	if dialogue_box.visible:
		next_line()


func _on_back_button_pressed():
	previous_line()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")


func _on_check_button_pressed():
	if all_words_placed():
		win_game()
	else:
		show_error()
