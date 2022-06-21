extends Resource
class_name NPC

const Units = preload("res://global/Units.tres")

export(String) var npc_id
var quest_item:Array= []
var quest_reward:Array = []

var npc_name
var npc_description
var initial_dialog
var chating_dialogs
var npc_quests

var first_meet = true
var quest_amount = 0
var quest_process = 0 setget set_quest_process
var rng = RandomNumberGenerator.new()

func _init(npc_id):
	self.npc_id = npc_id
	self._ready()

func _ready():
	rng.randomize()
	
	if DataBase.npcs_data.keys().has(npc_id):
		var npc = DataBase.npcs_data[npc_id]
		npc_name = npc["npc_name"]
		npc_description = npc["npc_description"]
		initial_dialog = npc["initial_dialog"]
		chating_dialogs = npc["chating_dialogs"]
		npc_quests = npc["npc_quests"] if npc.keys().has("npc_quests") else []
		quest_amount = npc_quests.size()
		print("%s is ready" % npc_id)
	else:
		printerr("%s is not exist" % npc_id)

func _to_string() -> String:
	return Bbcode.wrap_npc("%s(%s)" % [npc_name,npc_id])
func get_dialog():
	if first_meet :
		first_meet = false
		return Bbcode.wrap_dialog(get_initial_dialog())
	else:
		var random = rng.randi_range(0,chating_dialogs.size()-1)
		return Bbcode.wrap_dialog(get_chatting_dialog(random))

func set_quest_process(value):
	quest_process = value

func get_quest_finished_dialog():
	return "%s: \"%s\"" % [npc_name,npc_quests[quest_process]["quest_finished_dialog"]]

func get_initial_dialog():
	return "%s: \"%s\"" % [npc_name,initial_dialog]

func get_chatting_dialog(index:int):
	return "%s: \"%s\"" % [npc_name,chating_dialogs[index]["chating_dialog"]]

func all_quests_finished():
	for quest in npc_quests:
		if quest["is_finished"] == false:
			return false
	return true

func get_post_quest_dialog():
	if npc_quests.empty():
		return "他無法給你任務"
	if all_quests_finished():
		return Bbcode.wrap_dialog("%s: \"%s\"" % [npc_name,"我已經沒什麼能給你做的了"])
	if !npc_quests[quest_process]["is_accepted"]:
		npc_quests[quest_process]["is_accepted"] = true
		return Bbcode.wrap_dialog("%s: \"%s\"" % [npc_name,npc_quests[quest_process]["post_quest_dialog"]])
	else:
		return Bbcode.wrap_dialog("%s: \"%s\"" % [npc_name,npc_quests[quest_process]["quest_not_finished_dialog"]])

func get_quest_response():
	if npc_quests[quest_process]["is_finished"]:
		chating_dialogs.append({
			"chating_dialog":npc_quests[quest_process]["finished_add_chatting"]
		})
		var response = get_quest_finished_dialog()+"\n"+apply_quest_reward(quest_reward[quest_process])
		quest_process += 1
		return response
		
func check_item(item):
	if item == quest_item[quest_process]:
		npc_quests[quest_process]["is_finished"] = true
		return true
	return false

func apply_quest_reward(reward):
	if reward is Exit:
		reward.unlock_exit(reward.get_another_room(Units.current_room))
		return "通往%s的出口打開了" % reward.get_another_room(Units.current_room)
	elif reward is MetaRoom:
		Units.current_room.connect_exist_unlocked("",reward,Units.secret_rooms[npc_id][0])
		return "一個出口突然出現在%s" % Directions.str2chinese(Units.secret_rooms[npc_id][0][0])
	elif reward is Item:
		Units.player.receive_reward(reward)
		return "你獲得了%s" % reward
	else:
		return ""
