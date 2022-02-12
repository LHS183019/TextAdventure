tool
extends PanelContainer
class_name MetaRoom

export(String) var room_name = "Room Name" setget set_room_name
export(String) var room_id = "Room id" setget set_room_id 
export(String,MULTILINE) var room_description = "Room Script" setget set_room_description
export(String,MULTILINE) var enter_story = "When_Enter"
###TODO: ADD ROOM TYPE, ADD ROOM EXIT DESCRIPTION

var room_exits:Dictionary = {}
var room_items:Array = []
var room_npcs:Array = []

func set_room_id(new_id):
	room_id = new_id
	$MarginContainer/Rows/TopicsRows/RoomId.text = new_id

func set_room_name(new_name:String):
	room_name = new_name
	$MarginContainer/Rows/TopicsRows/RoomName.text = new_name

func _to_string() -> String:
	return "%s(%s)" % [room_name,room_id]

func set_room_description(new_description:String):
	room_description = new_description
	$MarginContainer/Rows/RoomDescription.text = new_description

func connect_exist_unlocked(direction,another_room,name_overide=[],connect_both=true)->Exit:
	return _connect_exists(direction,another_room,false,false,connect_both,name_overide)

func connect_exist_locked(direction,another_room,name_overide=[],lock_type="outside",connect_both=true)->Exit:
	if lock_type == "inside":	
		return _connect_exists(direction,another_room,true,false,connect_both,name_overide)
	elif lock_type == "outside":
		return _connect_exists(direction,another_room,false,true,connect_both,name_overide)
	else:
		return _connect_exists(direction,another_room,true,true,connect_both,name_overide)


func _connect_exists(direction:String,another_room,locked_1=false,locked_2=false,two_side=true,name_overide=[])->Exit:
	var exit = Exit.new()
	exit.room_1 = self
	exit.room_2 = another_room
	exit.is_room_1_locked = locked_1
	exit.is_room_2_locked = locked_2
	
	if !name_overide.empty():
		self.room_exits[name_overide[0]] = exit
		if two_side:
			another_room.room_exits[name_overide[1]] = exit
	else:
		self.room_exits[direction] = exit
		if two_side:
			another_room.room_exits[Directions.reverse(direction)] = exit
	return exit

func add_new_item(new_item:Item):
	room_items.append(new_item)

func remove_item(item:Item):
	room_items.erase(item)
	
func add_new_npc(new_npc):
	room_npcs.append(new_npc)

func remove_npc(npc:Item):
	room_npcs.erase(npc)

func get_full_description():
	var full_description = PoolStringArray([get_room_description()] )
	if !room_items.empty():
		full_description.append(get_room_items_description())
	if !room_npcs.empty():
		full_description.append(get_room_npcs_description())
	full_description.append(get_room_exits_description())
	full_description = full_description.join('\n')
	return full_description

func get_room_description():
	return room_description

func get_room_name_decription():
	return "你現在處於 %s " % self

func get_room_items_description():
	var items = PoolStringArray(room_items).join(",")
	return "這裏有: %s" % items
	
func get_room_npcs_description():
	var npcs = PoolStringArray(room_npcs).join(",")
	return "人物有: %s" % npcs
	
func get_room_exits_description():
	var exits = PoolStringArray(room_exits.keys()).join(",")
	return "出口: %s" % exits

