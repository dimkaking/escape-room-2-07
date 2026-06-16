extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

@onready var puzzle_board = $PuzzleBoard
@onready var pieces = $Pieces

@onready var student_sprite_1 = $StudentSprite
@onready var student_sprite_2 = $StudentSprite2

@onready var back_button = $BackButton
@onready var exit_button = $ExitButton

var speakers := [
	"Traveler",
	"Mr. Robot",
	"Traveler",
	"Mr. Robot"
]

var lines := [
	"Hey!",
	"Siehst du das Puzzle auf dem Tisch?",
	"Wir sitzen schon ewig daran und kommen einfach nicht weiter.",
	"Vielleicht können wir dir helfen, aus unserem Klassenzimmer rauszukommen, wenn du uns beim Puzzle hilfst."
]

var line_index := 0
var task_finished := false
var task_completed_saved := false


func _ready():
	puzzle_board.visible = true
	pieces.visible = true
	dialogue_box.visible = true

	back_button.visible = true
	exit_button.visible = true
	
	set_pieces_enabled(false)
	show_dialogue()


func _input(event):
	if event.is_action_pressed("ui_accept") and dialogue_box.visible:
		next_line()


func set_pieces_enabled(value: bool):
	for piece in pieces.get_children():
		if "can_drag" in piece:
			piece.can_drag = value


func show_dialogue():
	name_label.text = speakers[line_index]
	text_label.text = lines[line_index]
	update_speaker_visual()


func next_line():
	line_index += 1

	if line_index >= lines.size():
		if task_finished:
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
		else:
			dialogue_box.visible = false
			back_button.visible = false
			show_puzzle()
	else:
		show_dialogue()


func previous_line():
	if not dialogue_box.visible:
		return

	if line_index > 0:
		line_index -= 1
		show_dialogue()


func show_puzzle():
	puzzle_board.visible = true
	pieces.visible = true
	set_pieces_enabled(true)
	show_both_students()


func show_both_students():
	student_sprite_1.modulate = Color(1, 1, 1, 1)
	student_sprite_2.modulate = Color(1, 1, 1, 1)


func update_speaker_visual():
	if speakers[line_index] == "Traveler":
		student_sprite_1.modulate = Color(1, 1, 1, 1)
		student_sprite_2.modulate = Color(0.55, 0.55, 0.55, 1)
	else:
		student_sprite_1.modulate = Color(0.55, 0.55, 0.55, 1)
		student_sprite_2.modulate = Color(1, 1, 1, 1)


func _on_next_button_pressed():
	if dialogue_box.visible:
		next_line()


func _on_back_button_pressed():
	previous_line()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")


func puzzle_completed():
	if task_completed_saved:
		return

	print("Puzzle gelöst!")

	task_completed_saved = true
	task_finished = true

	GameState.complete_current_task("tisch3_puzzle")

	set_pieces_enabled(false)

	dialogue_box.visible = true
	back_button.visible = true
	
	speakers = [
		"Traveler",
		"Mr. Robot"
	]
	
	lines = [
		"Wow, du hast das Puzzle gelöst!",
		"Danke! Jetzt können wir dir weiterhelfen."
	]
	
	line_index = 0
	show_dialogue()
