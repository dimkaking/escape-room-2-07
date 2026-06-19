extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var menu_button = $MenuButton

func _ready():
	menu_button.visible = false
	animation_player.play("ending")


func play_door_sound():
	$DoorOpenSound.play()


func show_title():
	$TitleLabel.visible = true


func show_credits():
	$CreditsLabel.visible = true


func show_menu_button():
	menu_button.visible = true


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
