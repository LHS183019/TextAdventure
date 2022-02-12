extends Node

var file = File.new()
var data = null
onready var items_data:Dictionary = {}
onready var npcs_data:Dictionary = {}

func _ready():
	print("database is ready")
	file.open("res://dataBase/TAdata.cdb", File.READ)
	data = parse_json(file.get_as_text())["sheets"]
	file.close()
	
	var temp = data[0]["lines"]
	for item in temp:
		var key = item["item_id"]
		var value_dic = item.duplicate(true)
		value_dic.erase("item_id")
		items_data[key] = value_dic
	
	var temp2 = data[1]["lines"]
	for npc in temp2:
		var key = npc["npc_id"]
		var value_dic = npc.duplicate(true)
		value_dic.erase("npc_id")
		npcs_data[key] = value_dic
