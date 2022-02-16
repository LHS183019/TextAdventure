extends MetaRoom


func _ready() -> void:
	pass # Replace with function body.

func enter_story():
	for i in range(enter_story.size()):
		yield(get_tree().create_timer(enter_story_timer[i]),"timeout")
		Units.game_info.create_response(enter_story[i])
	Event.emit_signal("change_room_to",get_parent().get_node("WoodHouse"))
