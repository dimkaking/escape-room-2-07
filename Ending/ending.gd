extends Node2D

@onready var door_closed = $DoorClosed
@onready var door_open = $DoorOpen
@onready var cat_sprite = $CatSprite
@onready var door_sound = $DoorOpenSound
@onready var fade_rect = $FadeRect
@onready var title_label = $TitleLabel
@onready var credits_label = $CreditsLabel
@onready var menu_button = $MenuButton
@onready var camera = $Camera2D

@export var cat_start_position := Vector2(430, 680)
@export var cat_door_position := Vector2(610, 680)
@export var cat_exit_position := Vector2(610, 450)
@export var camera_door_position := Vector2(610, 330)


func _ready():
	door_closed.visible = true
	door_open.visible = false

	title_label.visible = false
	credits_label.visible = false
	menu_button.visible = false

	setup_fade_rect()

	camera.enabled = true

	cat_sprite.global_position = cat_start_position
	cat_sprite.play("run_up")

	start_ending()


func setup_fade_rect():
	fade_rect.visible = true
	fade_rect.color = Color.WHITE
	fade_rect.modulate.a = 0.0
	fade_rect.z_index = 1000
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	fade_rect.anchor_left = 0
	fade_rect.anchor_top = 0
	fade_rect.anchor_right = 1
	fade_rect.anchor_bottom = 1
	fade_rect.offset_left = 0
	fade_rect.offset_top = 0
	fade_rect.offset_right = 0
	fade_rect.offset_bottom = 0


func start_ending():
	await get_tree().create_timer(0.8).timeout

	cat_sprite.play("run_up")

	var cat_tween = create_tween()
	cat_tween.tween_property(cat_sprite, "global_position", cat_door_position, 2.2)

	await cat_tween.finished

	cat_sprite.stop()

	await get_tree().create_timer(0.4).timeout

	door_sound.play()
	door_closed.visible = false
	door_open.visible = true

	await get_tree().create_timer(0.6).timeout

	cat_sprite.play("run_up")

	var cat_exit_tween = create_tween()
	cat_exit_tween.tween_property(cat_sprite, "global_position", cat_exit_position, 1.4)

	await cat_exit_tween.finished

	cat_sprite.visible = false

	var camera_tween = create_tween()
	camera_tween.tween_property(camera, "zoom", Vector2(2.8, 2.8), 3.0)
	camera_tween.parallel().tween_property(camera, "global_position", camera_door_position, 3.0)

	await camera_tween.finished

	var fade_tween = create_tween()
	fade_tween.tween_property(fade_rect, "modulate:a", 1.0, 2.0)

	await fade_tween.finished

	show_credits()


func show_credits():
	title_label.z_index = 1001
	credits_label.z_index = 1001
	menu_button.z_index = 1001

	title_label.visible = true
	credits_label.visible = true

	await get_tree().create_timer(3.0).timeout

	menu_button.visible = true


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
