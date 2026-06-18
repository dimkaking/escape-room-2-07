extends Node2D

@export var pickup_item_scene: PackedScene

func _ready() -> void:
	MenuMusic.stop_music()

	if GameState.has_return_position:
		$Raum_2_07/Player.global_position = GameState.player_return_position
	
	print("PENDING ITEM: ", GameState.pending_drop_item)
	spawn_pending_item()


func spawn_pending_item():
	if GameState.pending_drop_item == "":
		return

	if GameState.is_item_picked(GameState.pending_drop_item):
		return

	var item_scene = null
	var drop_point = null

	match GameState.pending_drop_item:
		"trash_bag":
			item_scene = preload("res://Items/TrashBagPickup.tscn")
			drop_point = $Raum_2_07/DropPoints/DropPoint1

		"puzzle_piece":
			item_scene = preload("res://Items/PuzzlePiecePickup.tscn")
			drop_point = $Raum_2_07/DropPoints/DropPoint2

		"glue":
			item_scene = preload("res://Items/GluePickup.tscn")
			drop_point = $Raum_2_07/DropPoints/DropPoint3

		"tablet":
			item_scene = preload("res://Items/TabletPickup.tscn")
			drop_point = $Raum_2_07/DropPoints/DropPoint4

		"geodreieck":
			item_scene = preload("res://Items/GeodreieckPickup.tscn")
			drop_point = $Raum_2_07/DropPoints/DropPoint5

		"pen":
			item_scene = preload("res://Items/PenPickup.tscn")
			drop_point = $Raum_2_07/DropPoints/DropPoint6

		"notebook":
			item_scene = preload("res://Items/NotebookPickup.tscn")
			drop_point = $Raum_2_07/DropPoints/DropPoint7

		"usb_stick":
			item_scene = preload("res://Items/UsbStickPickup.tscn")
			drop_point = $Raum_2_07/DropPoints/DropPoint8

		"door_key":
			item_scene = preload("res://Items/DoorKeyPickup.tscn")
			drop_point = $Raum_2_07/DropPoints/DropPoint9

	if item_scene == null or drop_point == null:
		print("No item scene or drop point for: ", GameState.pending_drop_item)
		return

	var item = item_scene.instantiate()
	item.item_name = GameState.pending_drop_item
	item.global_position = drop_point.global_position
	add_child(item)
