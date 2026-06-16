extends Node2D

@onready var dialogue_box = $DialogueBox
@onready var name_label = $DialogueBox/NameLabel
@onready var text_label = $DialogueBox/TextLabel

# Начальные реплики Дильшада
var lines := [
	"Hallo!",
	"Gleich beginnt der Matheunterricht, und ich habe gerade bemerkt, dass ich mein Geodreieck verloren habe.",
	"Wenn Herr Bruno das herausfindet, bin ich erledigt...",
	"Ich habe schon unter jeder Bank nachgesehen, aber es ist einfach nirgends zu finden.",
	"Hilf mir, das Geodreieck zu finden, bevor der Unterricht beginnt, und ich werde dir garantiert dabei helfen, aus unserem Klassenzimmer zu entkommen!"
]

# Финальные реплики после нахождения всех 5 линеек
var finish_lines := [
	"Großartig!",
	"Du hast alle 5 Geodreiecke gefunden!",
	"Jetzt kann der Matheunterricht losgehen, ohne dass Herr Bruno meckert.",
	"Wie versprochen, helfe ich dir jetzt beim Entkommen.",
	"Viel Erfolg! Los geht's!"
]

var line_index := 0
var is_finishing := false

# Логика для 5 фотографий
var current_stage := 0
var max_stages := 5

func _ready() -> void:
	dialogue_box.visible = true
	
	# Сюда в будущем добавишь скрытие узлов с картинками при старте:
	# Например: $PhotoContainer.visible = false
	
	show_dialogue()

func show_dialogue() -> void:
	name_label.text = "Dil" # Имя персонажа
	
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
			# Конец игры — переход в главный класс
			get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")

func _on_back_button_pressed() -> void:
	if line_index > 0:
		line_index -= 1
		show_dialogue()

func start_task() -> void:
	dialogue_box.visible = false
	current_stage = 0
	print("Начался поиск! Показываем фото №", current_stage + 1)
	
	# КОД НА БУДУЩЕЕ:
	# Здесь ты включишь видимость контейнера с фотографиями:
	# $PhotoContainer.visible = true
	# И вызовешь функцию обновления картинки, например: update_stage_ui()

# --- ФУНКЦИЯ ДЛЯ СЛЕДУЮЩИХ ШАГОВ ---
# Эту функцию ты будешь вызывать каждый раз, когда игрок успешно кликнет 
# на спрятанную линейку (Geodreieck) на текущей фотографии.
func _on_ruler_found() -> void:
	current_stage += 1
	print("Линейка найдена! Переходим к фото №", current_stage + 1)
	
	if current_stage >= max_stages:
		# Если успешно прошли все 5 фоток
		finish_game()
	else:
		# Если ещё остались фотографии, меняем картинку
		# Пример на будущее: update_stage_ui()
		pass

func finish_game() -> void:
	print("Все 5 линеек успешно собраны!")
	is_finishing = true
	line_index = 0
	
	# КОД НА БУДУЩЕЕ:
	# Прячем узел с фотографиями поиска, так как игра завершена
	# $PhotoContainer.visible = false
	
	# Показываем финальный диалог
	dialogue_box.visible = true
	show_dialogue()



func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Raum/raum_2_07.tscn")
