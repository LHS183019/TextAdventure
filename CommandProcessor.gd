extends Node

const division_line = "\n--------------------------\n"
const Units = preload("res://global/Units.tres")


var command_set_help:Dictionary = {
	"askquest":"askquest {people_name} 詢問房間裏的某個人有沒有任務",
	"drop":"drop {item_name} 扔掉你背包裡的某道具",
	"exit":"離開遊戲",
	"give":"give {item_name} {people_name} 把某物品交給某人物",
	"go":"go {exit} 使玩家移動到某方向的出口 'help direction'來查看游戲裏可能出現的方向",
	"help":"help {command} 查看某指令的使用方式 只鍵入'help'可查看游戲所有可用指令",
	"inventory":"查看玩家持有的道具",
	"lookat":"lookat {item_name/people_name} 觀察房間或背包內的某物品或人物",
	"lookaround":"查看房間描述",
	"move":"同go",
	"pick":"同take",
	"quest":"查看玩家已有的任務(未完成)",
	"talk":"talk {people_name} 與房間裏的某個人談話",
	"take":"take {item_name} 撿起房間中的某個物品",
	"use":"use {item_name} {use_on} 把某道具使用到某對象身上",
	"where":"查看所處地點"
}
var other_help = {
	"direction":"EAST,WEST,SOUTH,NORTH,UP,DOWN,EASTSOUTH,EASTNORTH,WESTSOUTH,WESTNORTH"
}

func _ready() -> void:
	Event.connect("change_room_to",self, "_handle_room_change")

func initialize(starting_room):
	Units.current_room = starting_room
	return change_room(starting_room)


func process_command(input:String)->String:
	var words = input.split(" ", false)
	if words.size() >= 1:
		var first_word = words[0].to_lower()
		var second_word = null
		var third_word = null
		if words.size() > 1:
			second_word = words[1].to_lower()
		if words.size() > 2:
			third_word = words[2].to_lower()
			
		match(first_word):
			"askquest","askq":
				return command_askq(second_word)
			"go","goto","move","moveto":
				return command_go(second_word)
			"give":
				return command_give(second_word,third_word)
			"use":
				return command_use(second_word,third_word)
			"help":
				return command_help(second_word)
			"take","takeup","pickup","pick":
				return command_take(second_word)
			"talk","talkto","speak","speakto","chat","chatwith":
				return command_talk(second_word)
			"drop":
				return command_drop(second_word)
			"inventory":
				return command_inventory()
			"walk":
				return "你踏著步兜了個圈"
			"lookat","look":
				return commmand_look(second_word)
			"watch":
				return command_watch(second_word)
			"lookaround":
				return command_lookaround()
			"where":
				return command_where()
			"hi","hey","hello":
				return "你好"
			"ok":
				return "好的"
			"thank","thankyou","thx","thanks":
				return "不用客氣？"
			"exit":
				return command_exit()
			_:
				if Units.current_room.room_exits.keys().has(Directions.auto_complete(first_word)):
					return command_go(Directions.auto_complete(first_word))
				else:
					return "什麽？"
		
	return "什麽?"
		
func command_exit():
	return "quit"

func command_watch(sth=null):
	if sth == null:
		return "你盯著空氣發呆..."
	sth = sth.to_lower()
	for room_item in Units.current_room.room_items:
		if room_item.item_id == sth:
			return "你盯著%s" % room_item
	for player_item in Units.player.inventory:
		if(player_item.item_id == sth):
			return "你從背包拿出了%s並盯著它看...\n" % player_item.item_name
	for room_npc in Units.current_room.room_npcs:
		if room_npc.npc_id == sth:
			return "你盯著%s" % room_npc
	for position in Units.current_room.room_exits.keys():
		var exit = Units.current_room.room_exits[position]
		if position == Directions.auto_complete(sth):
			return "你盯著%s" % Directions.str2chinese(position)	
	return "你盯著空氣發呆..."

func commmand_look(sth=null):
	if sth == null:
		return "看什麼?"
	sth = sth.to_lower()
	for room_item in Units.current_room.room_items:
		if room_item.item_id == sth:
			return room_item.item_description
	for player_item in Units.player.inventory:
		if(player_item.item_id == sth):
			return "你從背包拿出了%s並看了看...\n%s" % [player_item.item_name, player_item.item_description]
	for room_npc in Units.current_room.room_npcs:
		if room_npc.npc_id == sth:
			return room_npc.npc_description
	for position in Units.current_room.room_exits.keys():
		var exit = Units.current_room.room_exits[position]
		if position == Directions.auto_complete(sth):
			return "你往%s望去，看到了%s" % [Directions.str2chinese(position),exit.get_another_room(Units.current_room)]
	
	return "？沒有這個東西可以觀察"
	
func command_inventory():
	return Units.player.get_inventory_list()

func command_take(item=null):
	if item == null:
		return "拿什麼?"
	if Units.current_room.room_items.empty():
			return "這裡沒什麼好撿的"
	item = item.to_lower()
	for room_item in Units.current_room.room_items:
		if room_item.item_id == item:
			if room_item.pickable:
				Units.current_room.remove_item(room_item)
				return Units.player.pickup_item(room_item)
			else:
				return "你撿%s幹什麼？" % room_item.item_name
	for room_npc in Units.current_room.room_npcs:
		if room_npc.npc_id == item:
			return "這可不是個道具"
	return "這裡沒有這個東西"
		
func command_talk(sb):
	if sb == null:
		return "和誰說?"
	if Units.current_room.room_npcs.empty():
		return "這裡沒有人可以聊天"
	sb = sb.to_lower()
	for room_npc in Units.current_room.room_npcs:
		if room_npc.npc_id == sb:
			return room_npc.get_dialog()
	for room_item in Units.current_room.room_items:
		if room_item.item_id == sb:
			return "你怎麽能和%s説話呢？"%room_item.item_name
	return "這裡沒有這個人物"

func command_askq(sb):
	if sb == null:
		return "問誰?"
	if Units.current_room.room_npcs.empty():
		return "這裡沒有人可以問"
	sb = sb.to_lower()
	for room_npc in Units.current_room.room_npcs:
		if room_npc.npc_id == sb:
			return room_npc.get_post_quest_dialog()
	for room_item in Units.current_room.room_items:
		if room_item.item_id == sb:
			return "你怎麽能和%s説話呢？"%room_item.item_name
	return "這裡沒有這個人物"

func command_give(sth,sb):
	if sth == null:
		return "給什麼？"
	if sb == null:
		return "給誰？"
	sth = sth.to_lower()
	sb = sb.to_lower()
	for player_item in Units.player.inventory:
		if player_item.item_id == sth:
			match player_item.item_type:
				Types.ItemTypes.QUESTITEM:
					return use_quest_item(player_item,sb)
				Types.ItemTypes.KEY:
					return use_quest_item(player_item,sb)
				_:
					return "系統裏沒有這種道具呀？您開挂了？"
	return "你沒有這個東西，怎麼給呢？"
				
func command_drop(item=null):
	if item == null:
		return "扔什麼?"
	item = item.to_lower()
	for player_item in Units.player.inventory:
		if(player_item.item_id == item):
			Units.player.drop_item(player_item)
			Units.current_room.add_new_item(player_item)
			return "你扔下了%s" % player_item.item_name
	for room_npc in Units.current_room.room_npcs:
		if room_npc.npc_id == item:
			return "這不是可以扔的東西"
	return "你沒有這個東西"
	
func command_use(item=null,use_on=null):
	if item == null:
		return "用什麼?"
	item = item.to_lower()
	for player_item in Units.player.inventory:
		if(player_item.item_id == item):
			if player_item.item_use_value.empty():
				return "這個不能用"
			match player_item.item_type:
				Types.ItemTypes.KEY:
					return use_key(player_item,use_on)
				_:
					return "這種道具不能用"
	return "你沒有這個東西，怎麼用呢?"

func use_key(key:Item,use_on=null):
	if use_on == null:
		return "用在哪兒？"
	
	for room_npc in Units.current_room.room_npcs:
		if room_npc.npc_id == use_on.to_lower():
			return "這可不是用在人身上的"
			
	use_on = Directions.auto_complete(use_on)
	if !Units.current_room.room_exits.keys().has(use_on):
		return "沒有這個方向"
	
	if Units.current_room.room_exits.keys().has(use_on):
		var exit = Units.current_room.room_exits[use_on]
		var another_room:MetaRoom = exit.get_another_room(Units.current_room)
		if exit.is_another_room_locked(Units.current_room):
			if key.item_use_value == another_room.room_id:		
				exit.unlock_exit(exit.get_another_room(Units.current_room))
				return "你用%s打開了通往%s的鎖" % [key,another_room]
			else:
				return "這個鑰匙(key)不是用在這裡的"
		else:
			return "這扇門已經打開了"
	else:
		return "這個方向可沒有出口"
		
func use_quest_item(player_item,sb):
	for room_npc in Units.current_room.room_npcs:
		if room_npc.npc_id == sb.to_lower():
			if room_npc.quest_item.empty():
				return "你給他幹嘛？"
			if room_npc.check_item(player_item):
				Units.player.drop_item(player_item)
				return room_npc.get_quest_response()
			return "%s: “我不需要這個。”" % room_npc.npc_name
	return "這裡沒有這個人"

func command_help(command=null)->String:
	if command == null:
		var help_text = ["可用的指令有:"]
		for command_name in command_set_help.keys():
			help_text.append(" %s: %s" %
			[command_name, command_set_help[command_name]])
		return PoolStringArray(help_text+[""]).join(division_line)
	
	command = command.to_lower()
	if command_set_help.keys().has(command):
		return command_set_help[command]
	elif other_help.keys().has(command):
		return other_help[command]
	else:
		return "你問的指令不存在"

func command_where():
	return Units.current_room.get_room_name_decription()

func command_lookaround():
	return Units.current_room.get_full_description()
	
func command_go(direction=null)->String:
	if direction == null:
		return "去哪裏？"
	
	for position in Units.current_room.room_exits.keys():
		var exit = Units.current_room.room_exits[position]
		if exit.get_another_room(Units.current_room).room_id == direction.to_lower():	
			return command_go(position)
	
	direction = Directions.auto_complete(direction)
	if Units.current_room.room_exits.keys().has(direction):
		var exit:Exit = Units.current_room.room_exits[direction]
		if exit.is_another_room_locked(Units.current_room):
			return "這個出口被鎖上了，你出不去"
		return PoolStringArray(["你向%s走去..." % Bbcode.wrap_direction(Directions.str2chinese(direction)), 
		"你進入了%s" % exit.get_another_room(Units.current_room),
		change_room(exit.get_another_room(Units.current_room))]).join("\n")
	elif !Units.current_room.room_exits.keys().has(direction):
		return "沒有這個方向"
	else:
		return "這個方向沒有出口"
	
func change_room(new_room:MetaRoom):
	Units.current_room = new_room
	var response_text = Units.current_room.get_full_description()
	Units.current_room.when_enter()
	Event.emit_signal("room_changed")
	return response_text


func _handle_room_change(room) -> void:
	Units.game_info.create_response(change_room(room))
