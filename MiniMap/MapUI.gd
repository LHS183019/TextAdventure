extends Control


const straight_line = Vector2(15,15)
const oblique_line = Vector2(25,30)
const Units = preload("res://global/Units.tres")
const MiniRoom = preload("res://MiniMap/MiniMapRoom.tscn")
onready var layer = {"ready":$"RoomControl/Level-Ready","-1":$"RoomControl/Level-1", "0":$RoomControl/Level0, "1":$RoomControl/Level1}

var current_room
var rooms = []

func _ready() -> void:
	Event.connect("generate_room",self,"_generate_mini_room")
	Event.connect("room_changed",self, "_handle_room_change")
	$CharacterPosition/ColorRect.color.a = 0
	
func initialize(big_rooms):
	for big_room in big_rooms:
		var mini_room = MiniRoom.instance()
		mini_room.initialize(big_room)
		rooms.append(mini_room)
		
	var start_room_mini = rooms[0]
	start_room_mini.position = Vector2(0,0)
	current_room = start_room_mini
	layer["0"].add_child(start_room_mini)
	

func _handle_room_change():
	current_room.hide_select()
	var play_anime = false
	for r in rooms:
		if r != null:
			if r.room_id == Units.current_room.room_id:
				current_room = r
				$CharacterPosition.position = current_room.global_position
				if $CharacterPosition.z_index != current_room.room_layer:
					$CharacterPosition/AnimationPlayer.play("out")
					yield($CharacterPosition/AnimationPlayer,"animation_finished")
					play_anime = true
					$CharacterPosition.z_index = current_room.room_layer
				current_room.show_select()
				check_element_show(play_anime)
				

func check_element_show(play_anime):
	for game_layer in layer.keys():
		layer[game_layer].hide()
	layer[str(current_room.room_layer)].show()
	for exit in current_room.room_exits:
		if exit != null and !exit.get_visibility(current_room):
			exit.hide()
	if play_anime:
		$CharacterPosition/AnimationPlayer.play("in")
		yield($CharacterPosition/AnimationPlayer,"animation_finished")
	
func _generate_mini_room(direction,this_room,another_room,two_side):
	var room
	var line
	var gererate_point:Vector2 = $CharacterPosition.position
	var gererate_layer = 0
	for r in rooms:
		if r != null:
			if r.room_id == this_room.room_id:
				gererate_point = r.position
				gererate_layer =  r.room_layer
			if r.room_id == another_room.room_id:
				room = r
			
			
	match(direction):
		"EAST":
			room.position = gererate_point + Vector2(125,0)
			room.room_layer = gererate_layer
			line = $LineEast.duplicate()
			line.initialize(current_room,room,two_side)
			line.position = gererate_point + Vector2(55,0)

		"WEST":
			room.position = gererate_point + Vector2(-125,0)
			room.room_layer = gererate_layer
			line = $LineWest.duplicate()
			line.initialize(current_room,room,two_side)
			line.position = gererate_point + Vector2(-55,0)
		
		"NORTH":
			room.position = gererate_point + Vector2(0,-75)
			room.room_layer = gererate_layer
			line = $LineNorth.duplicate()
			line.initialize(current_room,room,two_side)
			line.position = gererate_point + Vector2(0,-30)
			
		"SOUTH":
			room.position = gererate_point + Vector2(0,75)
			room.room_layer = gererate_layer
			line = $LineSouth.duplicate()
			line.initialize(current_room,room,two_side)
			line.position = gererate_point + Vector2(0,30)
		
		"UP":
			room.position = gererate_point
			room.room_layer = gererate_layer + 1
		
		"DOWN":
			room.position = gererate_point
			room.room_layer = gererate_layer - 1
			
		_:
			pass
	
	
	if room != null:
		if line != null:
			room.add_exit(line)
			current_room.add_exit(line)
			layer[str(room.room_layer)].add_child(line)
		layer[str(room.room_layer)].add_child(room)
