extends Button


func _on_ExploreMapBtn_pressed() -> void:
	Event.emit_signal("map_exploration_change",true)
