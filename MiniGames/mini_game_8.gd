extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

@onready var left_button = $LeftButton
@onready var right_button = $RightButton
@onready var photo_display = $PhotoDisplay
@onready var ruler_button = $RulerButton

@onready var back_button = $BackButton
@onready var exit_button = $ExitButton

@export var photos: Array[Texture2D] = []

var lines := [
	"Hallo!",
	"Gleich beginnt der Matheunterricht, und ich habe gerade bemerkt, dass ich mein Geodreieck verloren habe.",
	"Wenn Herr Bruno das herausfindet, bin ich erledigt...",
	"Ich habe schon unter jeder Bank nachgesehen, aber es ist einfach nirgends zu finden.",
	"Hilf mir, das Geodreieck zu finden, bevor der Unterricht beginnt, und ich werde dir garantiert dabei helfen, aus unserem Klassenzimmer zu entkommen!"
]

var finish_lines := [
	"Großartig!",
	"Du hast das Geodreieck gefunden!",
	"Jetzt kann der Matheunterricht losgehen, ohne dass Herr Bruno meckert.",
	"Wie versprochen, helfe ich dir jetzt beim Entkommen.",
	"Behalte diesen USB-Stick für die Flucht",
	"Viel Erfolg! Los geht's!"
]

var line_index := 0
var current_view_index := 0
var task_finished := false
var task_completed_saved := false


func _ready() -> void:
	dialogue_box.visible = true
	back_button.visible = true
	exit_button.visible = true

	left_button.visible = false
	right_button.visible = false
	photo_display.visible = false
	ruler_button.visible = false

	show_dialogue()


func _input(event):
	if event.is_action_pressed("ui_accept") and dialogue_box.visible:
		next_line()


func show_dialogue() -> void:
	name_label.text = "Dilschad"
	text_label.text = lines[line_index]


func next_line():
	line_index += 1

	if line_index >= lines.size():
		if task_finished:
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
		else:
			start_task()
	else:
		show_dialogue()


func previous_line():
	if not dialogue_box.visible:
		return

	if line_index > 0:
		line_index -= 1
		show_dialogue()


func start_task() -> void:
	dialogue_box.visible = false
	back_button.visible = false

	current_view_index = 0

	left_button.visible = true
	right_button.visible = true
	photo_display.visible = true

	update_photo_view()


func update_photo_view() -> void:
	if photos.size() < 4:
		print("Bitte lade 4 Bilder in den Inspector!")
		return

	photo_display.texture = photos[current_view_index]

	ruler_button.visible = current_view_index == 2


func _on_left_button_pressed() -> void:
	current_view_index -= 1

	if current_view_index < 0:
		current_view_index = 3

	update_photo_view()


func _on_right_button_pressed() -> void:
	current_view_index += 1

	if current_view_index > 3:
		current_view_index = 0

	update_photo_view()


func _on_ruler_button_pressed() -> void:
	win_game()


func win_game():
	task_finished = true

	if not task_completed_saved:
		task_completed_saved = true
		GameState.complete_current_task("tisch8_geodreieck", "usb_stick")

	left_button.visible = false
	right_button.visible = false
	photo_display.visible = false
	ruler_button.visible = false

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
