extends Node2D

var room_name setget _set_room_name
var room_id setget _set_room_id
var room_exits = []
var room_layer = 0

func _set_room_name(value):
	room_name = value
	$Container/MarginContainer/RoomInfo/RoomName.text = value
	
func _set_room_id(value):
	room_id = value
	$Container/MarginContainer/RoomInfo/RoomId.text = value	
	
func _ready() -> void:
	$ColorRect.hide()
	pass # Replace with function body.

func show_select():
	$ColorRect.show()

func hide_select():
	$ColorRect.hide()

func initialize(room) -> void:
	_set_room_name(room.room_name)
	_set_room_id(room.room_id)

func add_exit(exit):
	room_exits.append(exit)
