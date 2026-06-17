extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

# --- ИСПРАВЛЕННЫЙ ДИАЛОГ НА НЕМЕЦКОМ ---
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

var line_index := 0

func _ready() -> void:
	if dialogue_box:
		dialogue_box.visible = true
	show_dialogue()

func show_dialogue() -> void:
	if name_label and text_label:
		name_label.text = "Dr. Borat"
		text_label.text = lines[line_index]

func _on_next_button_pressed() -> void:
	if line_index < lines.size() - 1:
		line_index += 1
		show_dialogue()
	else:
		if dialogue_box:
			dialogue_box.visible = false
		print("Диалог завершен. Старт финального задания на C++!")

func _on_back_button_pressed() -> void:
	if line_index > 0:
		line_index -= 1
		show_dialogue()

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
