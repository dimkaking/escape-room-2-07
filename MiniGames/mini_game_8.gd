extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

@onready var left_button = $LeftButton
@onready var right_button = $RightButton
@onready var photo_display = $PhotoDisplay

# --- НОВОЕ: Ссылка на секретную кнопку-линейку ---
# Убедись, что кнопка на сцене называется именно так, с большой буквы: RulerButton
@onready var ruler_button = $RulerButton

# --- МАГИЯ ЭКСПОРТА ---
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
	"Viel Erfolg! Los geht's!"
]

var line_index := 0
var is_finishing := false
var current_view_index := 0

func _ready() -> void:
	dialogue_box.visible = true
	
	if left_button: left_button.visible = false
	if right_button: right_button.visible = false
	if photo_display: photo_display.visible = false
	
	# --- НОВОЕ: Прячем линейку в самом начале диалога ---
	if ruler_button: 
		ruler_button.visible = false
	
	show_dialogue()

func show_dialogue() -> void:
	name_label.text = "Dilschad"
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
			start_task()
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

func start_task() -> void:
	dialogue_box.visible = false
	current_view_index = 0
	
	if left_button: left_button.visible = true
	if right_button: right_button.visible = true
	if photo_display: photo_display.visible = true
	
	update_photo_view()

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

# --- ФУНКЦИЯ СМЕНЫ ФОТОГРАФИЙ ---
func update_photo_view() -> void:
	if photos.size() >= 4 and photo_display:
		photo_display.texture = photos[current_view_index]
		
		if ruler_button:
			# Теперь линейка будет появляться ТОЛЬКО на картинке под номером 2 в массиве
			if current_view_index == 2: 
				ruler_button.visible = true
			else:
				ruler_button.visible = false
	else:
		print("Внимание: Загрузи 4 картинки в Инспекторе!")
# Эту функцию вызовем при нахождении линейки
func _on_ruler_found() -> void:
	if left_button: left_button.visible = false
	if right_button: right_button.visible = false
	if photo_display: photo_display.visible = false
	
	# --- НОВОЕ: Прячем саму линейку после её успешного нахождения ---
	if ruler_button: 
		ruler_button.visible = false
	
	is_finishing = true
	line_index = 0
	dialogue_box.visible = true
	show_dialogue()

# --- ИЗМЕНЕНО: Клик по кнопке-линейке ---
func _on_ruler_button_pressed() -> void:
	print("Ура! Линейка найдена!")
	_on_ruler_found() # Активируем финал и диалог победы
