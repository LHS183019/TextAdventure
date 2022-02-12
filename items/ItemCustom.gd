extends Resource
class_name ItemCrustom

export(String) var item_name := "item_name"
export(String) var item_id := "item_id"  # id should always keep in lower case
export(Types.ItemTypes) var item_type := Types.ItemTypes.KEY
export(String, MULTILINE) var item_description := "item_description"

var item_use_value

func _init(item_name,item_id,item_type,item_description="",no_description=false) -> void:
	self.item_name = item_name
	self.item_id = item_id
	self.item_type = item_type
	if no_description:
		self.item_description = "這個沒什麼好看的"
	else:
		if(item_description.empty()):
			self.item_description = "這是個%s" % self.item_name
		else:
			self.item_description = item_description

func _to_string() -> String:
	return "%s(%s)" % [item_name,item_id]
