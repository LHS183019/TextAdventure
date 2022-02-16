extends Node


const DIALOG_COLOR = Color("#c3ff94")
const NPC_COLOR = Color("#94b9ff")
const ITEM_COLOR = Color("#ffd394")
const DIRECTION_COLOR = Color("#faff94")

const COLOR_YELLOW = Color("#FFFF8D")
const COLOR_GREEN = Color("#c3ff94")
const COLOR_BLUE = Color("#94b9ff")
const COLOR_ORANGE = Color("#ffd394")

func wrap_direction(direction:String):
	return "[color=#%s]%s[/color]" % [DIRECTION_COLOR.to_html(),direction]
	
func wrap_npc(npc:String):
	return "[color=#%s]%s[/color]" % [NPC_COLOR.to_html(),npc]
	
func wrap_item(item:String):
	return "[color=#%s]%s[/color]" % [ITEM_COLOR.to_html(),item]

func wrap_dialog(dialog:String):
	return "[color=#%s]%s[/color]" % [DIALOG_COLOR.to_html(),dialog]
