extends Node2D

@export var pickup_item_scene: PackedScene

func _ready() -> void:
	MenuMusic.stop_music()

	if GameState.has_return_position:
		$Raum_2_07/Player.global_position = GameState.player_return_position

	spawn_pending_item()


func spawn_pending_item():
	if GameState.pending_drop_item == "":
		return

	if GameState.is_item_picked(GameState.pending_drop_item):
		return

	var item = pickup_item_scene.instantiate()
	item.item_name = GameState.pending_drop_item

	match GameState.pending_drop_item:
		"pen":
			item.global_position = $Raum_2_07/DropPoints/DropPoint1.global_position
		"paper":
			item.global_position = $Raum_2_07/DropPoints/DropPoint2.global_position
		"usb":
			item.global_position = $Raum_2_07/DropPoints/DropPoint3.global_position
		"fork":
			item.global_position = $Raum_2_07/DropPoints/DropPoint4.global_position
		"tablet":
			item.global_position = $Raum_2_07/DropPoints/DropPoint5.global_position
		"ruler":
			item.global_position = $Raum_2_07/DropPoints/DropPoint6.global_position
		"note":
			item.global_position = $Raum_2_07/DropPoints/DropPoint7.global_position

	add_child(item)
