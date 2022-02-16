extends Node

var inventory := []
var quest := []
const Units = preload("res://global/Units.tres")
	
func _ready() -> void:
	Units.player = self

func pickup_item(item:Item):
	inventory.append(item)
	return "你撿起了%s並把它放入背包(inventory)" % item.item_name

func add_quest(new_quest):
	quest.append(new_quest)

func get_inventory_list():
	if inventory.size() == 0:
		return "背包是空的"
	var inventory_list = PoolStringArray(inventory).join(",")
	return "背包: %s" % inventory
	
func drop_item(item:Item):
	inventory.erase(item)

func receive_reward(reward):
	if reward == null:
		return
	else:
		inventory.append(reward)
