extends Resource
class_name Item

export(String) var item_id := "item_id"
export(String) var item_use_value = ""
var item_name = "item_name"  # id should always keep in lower case
var item_type:int = Types.ItemTypes.KEY
var item_description = "item_description"

var pickable = true

func _to_string() -> String:
	return Bbcode.wrap_item("%s(%s)" % [item_name,item_id])
	
func _ready():
	if DataBase.items_data.keys().has(item_id):
		var item:Dictionary = DataBase.items_data[item_id]
		item_name = item["item_name"]
		item_type = item["item_type"]
		item_description = item["item_description"]
		pickable = item["pickable"]
		print("%s is ready" % item_id)
	else:
		printerr("%s is not exist" % item_id)
