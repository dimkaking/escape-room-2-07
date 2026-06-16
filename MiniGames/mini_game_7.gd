extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

@onready var sentence_panel = $SentencePanel
@onready var answer_box = $SentencePanel/AnswerBox
@onready var word_buttons = $SentencePanel/WordButtons
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

var correct_order := [
	"Pau",
	"stört den Unterricht,",
	"weil er",
	"ständig redet."
]

var selected_words := []


func _ready():
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
	
	selected_words.clear()
	update_answer_box()

	for word in word_buttons.get_children():
		word.visible = true
		word.placed = false
		word.set_meta("start_position", word.global_position)


func add_word(word: String):
	if selected_words.size() >= correct_order.size():
		return
	
	selected_words.append(word)
	update_answer_box()


func update_answer_box():
	for child in answer_box.get_children():
		child.queue_free()

	for word in selected_words:
		var label = Label.new()
		label.text = word
		answer_box.add_child(label)


func _on_clear_button_pressed():
	selected_words.clear()
	update_answer_box()

	for word in word_buttons.get_children():
		word.visible = true
		word.placed = false

		if word.has_meta("start_position"):
			word.global_position = word.get_meta("start_position")


func _on_check_button_pressed():
	if selected_words == correct_order:
		win_game()
	else:
		selected_words.clear()
		update_answer_box()


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


func _on_next_button_pressed():
	if dialogue_box.visible:
		next_line()


func _on_back_button_pressed():
	previous_line()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
	
func try_place_word(word_piece):
	var distance = word_piece.global_position.distance_to(answer_box.global_position)

	if distance < 120:
		add_word(word_piece.word_text)
		word_piece.placed = true
		word_piece.visible = false
	else:
		word_piece.global_position = word_piece.get_meta("start_position")
