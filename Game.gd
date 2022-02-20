extends Control

const Units = preload("res://global/Units.tres")

var player_guide = "歡迎來到文字冒險！你可以鍵入'help'來查看可用指令，並用'exit'來離開遊戲。"

onready var command_processor = $CommandProcessor
onready var room_manager = $RoomManager
onready var game_info = $BackGround/MarginContainer/HBoxContainer/Rows/GameInfo
onready var mini_map = $BackGround/MarginContainer/HBoxContainer/SidePanel/MarginContainer/Rows/Map/MapView/MiniMap

func _ready() -> void:
	mini_map.initialize(room_manager.get_children())
	room_manager.initialize()
	var response = command_processor.initialize(room_manager.get_child(0))
	game_info.create_response(player_guide)
	game_info.create_response(response)



func _on_Input_text_entered(input_text: String) -> void:
	if input_text.empty():
		return
	var response_text = command_processor.process_command(input_text)
	if response_text == "quit":
		get_tree().quit()
	else:
		game_info.create_response(response_text,input_text)
