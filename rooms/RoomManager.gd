extends Node

const Units = preload("res://global/Units.tres")


func initialize() -> void:
	# AWARE: The first room on code must be the starting room of current chapter.
	Units.secret_rooms["developer_soul"] = [["WEST","EAST"],$Unkown]
	
	var gem:Item = load_item("gem")
	
	var black_key:Item = load_item("black_key")
	$Unkown.add_new_item(black_key)
	$EmptyRoom.connect_exist_locked("NORTH",$Outside,[],"outside",false)
	$EmptyRoom.connect_exist_unlocked("UP",$DeveloperRoom)
	$EmptyRoom.connect_exist_unlocked("EAST",$TrainingRoom)
	var man:NPC = load_npc("man")
	man.quest_item.append(gem)
	man.quest_reward.append($EmptyRoom.room_exits["NORTH"])
	$EmptyRoom.add_new_npc(man)

	var trainer:NPC = load_npc("trainer")
	var stick:Item = load_item("stick")
	trainer.quest_item.append(stick)
	trainer.quest_reward.append(gem)
	$TrainingRoom.add_new_npc(trainer)
	$TrainingRoom.add_new_item(stick)
	
	var soul = load_npc("developer_soul")
	soul.quest_item.append(gem)
	soul.quest_reward.append($Unkown)
	$DeveloperRoom.add_new_npc(soul)
	var broad = load_item("broad")
	$DeveloperRoom.add_new_item(broad)

func load_item(item_name:String)->Item:
	var temp = Item.new(item_name)
	return temp

func load_npc(npc_name:String)->NPC:
	var temp = NPC.new(npc_name)
	return temp
