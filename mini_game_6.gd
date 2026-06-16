extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel
@onready var answer_input = $LineEdit 
@onready var task_image = $aufgabe   
@onready var check_button = $prüfen  
@onready var antwort_label = $antwort

# Начальные реплики Люми
var lines := [
	"Hallo!",
	"In letzter Zeit gibt uns Herr Bruno so viele Hausaufgaben, dass ich kaum noch hinterherkomme.",
	"Mir fehlt einfach die Zeit, deshalb brauche ich deine Hilfe.",
	"Es gibt eine Aufgabe, die ich einfach nicht verstehe.",
	"Löse sie für mich, und ich werde versuchen, dir dabei zu helfen, aus dem Klassenzimmer zu entkommen."
]

# --- НОВОЕ: Финальные реплики после правильного ответа ---
var finish_lines := [
	"Super!",
	"Du hast das Rätsel richtig gelöst!",
	"Jetzt konnte ich das Tablet entsperren.",
	"Vielen Dank für deine Hilfe!",
	"Viel Erfolg auf deinem weiteren Weg! Gehen wir!"
]

var line_index := 0
var entered_pin := ""
var correct_pin := "100"

# --- НОВОЕ: Переключатель состояния диалога ---
# false — идет начальный диалог, true — идет финальный диалог
var is_finishing := false

func _ready():
	dialogue_box.visible = true
	
	# Прячем элементы задачи в самом начале
	if answer_input:
		answer_input.visible = false
	if task_image:
		task_image.visible = false
	if check_button:
		check_button.visible = false
	if antwort_label:
		antwort_label.visible = false
		
	show_dialogue()

func show_dialogue():
	name_label.text = "Lumi"
	
	# --- НОВОЕ: Проверяем, какой массив текста сейчас показывать ---
	if not is_finishing:
		text_label.text = lines[line_index]
	else:
		text_label.text = finish_lines[line_index]

func _on_next_button_pressed():
	# Если идет НАЧАЛЬНЫЙ диалог
	if not is_finishing:
		if line_index < lines.size() - 1:
			line_index += 1
			show_dialogue()
		else:
			start_task()
			
	# --- НОВОЕ: Если идет ФИНАЛЬНЫЙ диалог ---
	else:
		if line_index < finish_lines.size() - 1:
			line_index += 1
			show_dialogue()
		else:
			# Переходим в главную игру, когда финальный диалог полностью закончился
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")

func _on_back_button_pressed():
	# Кнопка назад работает одинаково для обоих диалогов
	if line_index > 0:
		line_index -= 1
		show_dialogue()

func start_task():
	dialogue_box.visible = false
	print("Hier startet später die Aufgabe.")
	
	if answer_input:
		answer_input.visible = true
		answer_input.text = "" 
	if task_image:
		task_image.visible = true
	if check_button:
		check_button.visible = true
	if antwort_label:
		antwort_label.visible = true
		antwort_label.text = "Bitte gib deine Antwort ein:" 

# Логика кнопки проверки
func _on_prüfen_pressed() -> void:
	var player_answer = answer_input.text.strip_edges()
	
	if player_answer == correct_pin:
		print("Правильно! Ответ 100.")
		
		# 1. Сначала ПРОСТО меняем текст в лейбле на "Супер!"
		# Картинка, кнопка и поле ввода пока остаются на месте!
		if antwort_label:
			antwort_label.text = "Super! Das ist richtig!" # "Супер! Это правильно!"
		
		# Опционально: отключаем кнопку, чтобы игрок не нажал её еще раз во время паузы
		if check_button:
			check_button.disabled = true
			
		# 2. Магия Godot: ждем ровно 2 секунды перед тем, как идти дальше
		await get_tree().create_timer(2.0).timeout
		
		# 3. И вот ТОЛЬКО СЕЙЧАС (спустя 2 секунды) переключаем игру в режим финала
		is_finishing = true
		line_index = 0 
		
		# Теперь прячем элементы задачки
		if answer_input: answer_input.visible = false
		if task_image: task_image.visible = false
		if antwort_label: antwort_label.visible = false
		if check_button: 
			check_button.visible = false
			check_button.disabled = false # возвращаем кнопку в исходное состояние
		
		# Включаем финальный диалог
		dialogue_box.visible = true
		show_dialogue()
			
	else:
		print("Неверный ответ! Попробуй еще раз.")
		answer_input.text = ""
		if antwort_label:
			antwort_label.text = "Deine Antwort ist falsch. 
			Versuche es noch einmal!"
