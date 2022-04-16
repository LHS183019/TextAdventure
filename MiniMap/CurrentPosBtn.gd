extends Button

func _ready() -> void:
	Event.connect("map_exploration_change",self,"_handle_explore")

func _handle_explore(exploring):
	self.visible = !self.visible


