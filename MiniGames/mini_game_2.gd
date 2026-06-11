extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

var lines := [
	"Hallo!",
	"Ich möchte heute früher von der Schule weg.",
	"Aber Herr Papia hat gesagt, dass ich erst das ganze Klassenzimmer aufräumen muss.",
	"Du musst mir helfen, die Papierstücke in den Mülleimer zu werfen.",
	"Dafür gebe ich dir etwas, das dir nützlich sein könnte."
]

var line_index := 0
var score = 0
signal paper_scored

func _ready():
	dialogue_box.visible = true
	show_dialogue()

func show_dialogue():
	name_label.text = "Max"
	text_label.text = lines[line_index]

func _on_next_button_pressed():
	if line_index < lines.size() - 1:
		line_index += 1
		show_dialogue()
	else:
		start_minigame()

func _on_back_button_pressed():
	if line_index > 0:
		line_index -= 1
		show_dialogue()

func start_minigame():
	dialogue_box.visible = false
	
func win_game():

	print("Победа!")

	# здесь можно выдать предмет
	# перейти в комнату
	# показать диалог Макса
func spawn_new_paper():

	$Paper.position = Vector2(700, 80)

	$Paper.falling = false	
func _on_paper_scored():

	score += 1

	print("Попаданий: ", score)

	if score >= 3:
		win_game()
	else:
		spawn_new_paper()


func _on_paper_area_entered(area):
	if area.name == "TrashCan":
		score += 1
		print("Попадание! ", score)

		spawn_new_paper()

		if score >= 3:
			win_game()
			


func _on_area_entered(area):
	print(area.name)

	if area.name == "MüllArea2D":
		paper_scored.emit()
	print(area.name)
