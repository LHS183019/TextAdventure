extends Resource
class_name Exit

var room_1 = null
var is_room_1_locked := false

var room_2 = null
var is_room_2_locked := false

func unlock_exit(room):
	if room == room_1:
		is_room_1_locked = false
	elif room == room_2:
		is_room_2_locked = false
	else:
		print("The room haven't been connected to any exits.")

func get_another_room(room):
	if room == room_1:
		return room_2
	elif room == room_2:
		return room_1
	else:
		print("The room haven't been connected to any exits.")
		return null

func is_another_room_locked(room):
	if room == room_1:
		return is_room_2_locked
	elif room == room_2:
		return is_room_1_locked
	else:
		print("The room haven't been connected to any exits.")
		return null
