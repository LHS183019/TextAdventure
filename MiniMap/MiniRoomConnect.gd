extends Line2D

var room1
var room2
var room1_visible = true
var room2_visible

func initialize(this, that, two_side):
	room1 = this
	room2 = that
	room2_visible = two_side

func get_visibility(room):
	if room == room1:
		return room1_visible
	elif room == room2:
		return room2_visible

func get_another_room(room):
	if room == room1:
		return room2
	elif room == room2:
		return room1
