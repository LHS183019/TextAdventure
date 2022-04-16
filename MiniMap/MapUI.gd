extends Control


const straight_line = Vector2(15,15)
const oblique_line = Vector2(25,30)
const Units = preload("res://global/Units.tres")
const MiniRoom = preload("res://MiniMap/MiniMapRoom.tscn")
onready var layers = {"0":$RoomControl/Level0}

var current_room # A MiniRoom,tracking on the current MiniRoom for camera move
var rooms = [] # mark all the MiniRoom instance in here

func _ready() -> void:
	Event.connect("generate_room",self,"_generate_mini_room")
	Event.connect("room_changed",self, "_handle_room_change")
	Event.connect("map_exploration_change",self,"_handle_explore")
	$"../CanvasLayer/ColorRect".color.a = 0 #for the fade in animation
	$"../".cur_cam = $"CharacterPosition/MiniMapCamera"
	
func initialize(big_rooms):
	# generate MiniRoomInstances
	for big_room in big_rooms:
		var mini_room = MiniRoom.instance()
		mini_room.initialize(big_room)
		rooms.append(mini_room)
		
	# initialize the starting room_to_generate
	var start_room_mini = rooms[0]
	start_room_mini.position = Vector2(0,0)
	current_room = start_room_mini
	layers["0"].add_child(start_room_mini)
	

# handle the minimap exploration
# switching the camera
func _handle_explore(is_exploring):
	if is_exploring:
		$"../".cur_cam = $"FullViewPosition/FullMiniMapCamera"
		$"../".cur_cam.current = true
	else:
		$"../".cur_cam = $"CharacterPosition/MiniMapCamera"
		$"../".cur_cam.current = true
		

func _handle_room_change():
	current_room.hide_select()
	var play_anime = false
	for r in rooms:
		if r != null:
			if r.room_id == Units.current_room.room_id:	
				var prev_room = current_room
				current_room = r
				$CharacterPosition.position = current_room.global_position
				if prev_room.room_layer != current_room.room_layer:
					$"../CanvasLayer/AnimationPlayer".play("out")
					yield($"../CanvasLayer/AnimationPlayer","animation_finished")
					play_anime = true
				current_room.show_select()
				check_element_show(play_anime)
				

func check_element_show(play_anime):
	# Check_the_visiable_layer
	for game_layer in layers.keys():
		layers[game_layer].hide()
	layers[str(current_room.room_layer)].show()
	
	# Check_the_visiable_line_
	for exit in current_room.room_exits:
		if exit != null and !exit.get_visibility(current_room):
			exit.hide()
			
	# Fade in animate
	if play_anime:
		$"../CanvasLayer/AnimationPlayer".play("in")
		yield($"../CanvasLayer/AnimationPlayer","animation_finished")
	
	
func _generate_mini_room(direction,this_room,another_room,two_side):
	var room_to_generate
	var line # a line instance
	var current_point:Vector2 = $CharacterPosition.position
	var current_layer = 0
	
	# find the position for "this_room" 
	# and the MiniRoom instance of the "another_room"
	for r in rooms:
		if r != null:
			if r.room_id == this_room.room_id:
				current_point = r.position
				current_layer =  r.room_layer
			if r.room_id == another_room.room_id:
				room_to_generate = r
				
			
	match(direction):
		# TODO: IMPLEMENT THE REST OF THE DIRECTION
		"EAST":
			room_to_generate.position = current_point + RoomPosition.RIGHTSIDE_OF_ROOM
			room_to_generate.room_layer = current_layer
			line = $LineEast.duplicate()
			line.initialize(current_room,room_to_generate,two_side)
			line.position = current_point + LinePosition.RIGHTSIDE_OF_ROOM

		"WEST":
			room_to_generate.position = current_point + RoomPosition.LEFTSIDE_OF_ROOM
			room_to_generate.room_layer = current_layer
			line = $LineWest.duplicate()
			line.initialize(current_room,room_to_generate,two_side)
			line.position = current_point + LinePosition.LEFTSIDE_OF_ROOM
		
		"NORTH":
			room_to_generate.position = current_point + RoomPosition.TOP_OF_ROOM
			room_to_generate.room_layer = current_layer
			line = $LineNorth.duplicate()
			line.initialize(current_room,room_to_generate,two_side)
			line.position = current_point + LinePosition.TOP_OF_ROOM
			
		"SOUTH":
			room_to_generate.position = current_point + RoomPosition.BOTTOM_OF_ROOM
			room_to_generate.room_layer = current_layer
			line = $LineSouth.duplicate()
			line.initialize(current_room,room_to_generate,two_side)
			line.position = current_point + LinePosition.BOTTOM_OF_ROOM
		
		"UP":
			room_to_generate.position = current_point
			room_to_generate.room_layer = current_layer + 1
		
		"DOWN":
			room_to_generate.position = current_point
			room_to_generate.room_layer = current_layer - 1
			
		_:
			pass
	
	if !layers.has(str(room_to_generate.room_layer)):
		layers[str(room_to_generate.room_layer)] = $LevelGenerator.generate(room_to_generate.room_layer)
	
	
	if room_to_generate != null:
		if line != null:
			# attach this exit(line) to both of the MiniRoom
			room_to_generate.add_exit(line)
			current_room.add_exit(line)
	
			# add Line to the layers(canvas)
			layers[str(room_to_generate.room_layer)].add_child(line)
		
		# add MiniRoom to the layers(canvas)
		layers[str(room_to_generate.room_layer)].add_child(room_to_generate)
