extends Button


func _ready() -> void:
	Event.connect("map_exploration_change",self,"_handle_explore")

func _on_ExploreMapBtn_pressed() -> void:
	Event.emit_signal("map_exploration_change",false)

	
func _handle_explore(exploring):
	self.visible = !self.visible
