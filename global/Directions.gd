extends Node

#DIRECTIONS SHOULD ALWAYS BE UPPER CASE

const DIRECTIONS = ["EAST","WEST","SOUTH","NORTH","UP","DOWN","EASTSOUTH","EASTNORTH","WESTSOUTH","WESTNORTH","INSIDE","OUTSIDE"]

static func reverse(direction:String)->String:
	match(direction):
		"EAST":
			return "WEST"
		"WEST":
			return "EAST"
		"SOUTH":
			return "NORTH"
		"NORTH":
			return "SOUTH"
		"UP":
			return "DOWN"
		"DOWN":
			return "UP"
		"EASTNORTH":
			return "WESTSOUTH"
		"WESTSOUTH":
			return "EASTNORTH"
		"EASTSOUTH":
			return "WESTNORTH"
		"WESTNORTH":
			return "EASTSOUTH"
		"INSIDE":
			return "OUTSIDE"
		_:
			print("No reversed direction")
			return ""
	""
static func auto_complete(direction_shortcut:String)->String:
	direction_shortcut = direction_shortcut.to_upper()
	match(direction_shortcut):
		"W","WEST":
			return "WEST"
		"E","EAST":
			return "EAST"
		"N","NORTH":
			return "NORTH"
		"S","SOUTH":
			return "SOUTH"
		"D","DOWN":
			return "DOWN"
		"U","UP":
			return "UP"
		"WS","WESTSOUTH":
			return "WESTSOUTH"
		"EN","EASTNORTH":
			return "EASTNORTH"
		"WN","WESTNORTH":
			return "WESTNORTH"
		"ES","EASTSOUTH":
			return "EASTSOUTH"
		"O","OUTSIDE":
			return "OUTSIDE"
		"I","INSIDE":
			return "INSIDE"
		_:
			return direction_shortcut
	return direction_shortcut
	
	
static func str_chinese_mapping(direction:String):
	match(direction):
		"EAST":
			return "東面"
		"WEST":
			return "西面"
		"SOUTH":
			return "南面"
		"NORTH":
			return "北面"
		"UP":
			return "上方"
		"DOWN":
			return "下方"
		"EASTNORTH":
			return "東北面"
		"WESTSOUTH":
			return "西南面"
		"EASTSOUTH":
			return "東南面"
		"WESTNORTH":
			return "西北面"
		"INSIDE":
			return "裡面"
		"OUTSIDE":
			return "外面"
		"PATH":
			return "小路"
		"FOREST":
			return "森林"
	
	return ""
	
static func str2chinese(direction:String)->String:
	return Bbcode.wrap_direction(str_chinese_mapping(direction))
