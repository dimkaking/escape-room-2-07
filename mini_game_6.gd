extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

var lines := [
	"Hallo!",
	"In letzter Zeit gibt uns Herr Bruno so viele Hausaufgaben, dass ich kaum noch hinterherkomme.",
	"Mir fehlt einfach die Zeit, deshalb brauche ich deine Hilfe.",
	"Es gibt eine Aufgabe, die ich einfach nicht verstehe.",
	"Löse sie für mich, und ich werde versuchen, dir dabei zu helfen, aus dem Klassenzimmer zu entkommen."
]

var line_index := 0

func _ready():

	dialogue_box.visible = true
	show_dialogue()

func show_dialogue():

	name_label.text = "Lumi"
	text_label.text = lines[line_index]

func _on_next_button_pressed():

	if line_index < lines.size() - 1:

		line_index += 1
		show_dialogue()

	else:

		start_task()

func _on_back_button_pressed():

	if line_index > 0:

		line_index -= 1
		show_dialogue()

func start_task():

	dialogue_box.visible = false

	print("Hier startet später die Aufgabe.")
