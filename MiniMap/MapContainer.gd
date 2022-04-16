extends ViewportContainer


func _ready() -> void:
	Event.connect("map_exploration_change",self, "_handle_explore")
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	# use this to pass the input to the minimap
	$MapView.input(event)


func _handle_explore(is_exploring):
	# handle the exploration of the minimap which leads to the change of the GUI
	if !is_exploring:
		get_node("MapView").gui_disable_input = true
		get_node("../../../../Rows").visible = true
		get_node("../Top").visible = true
		get_node("../ButtonList").visible = true
		get_node("../../../").size_flags_horizontal = SIZE_FILL
	else:
		get_node("MapView").gui_disable_input = false
		get_node("../../../").size_flags_horizontal = SIZE_EXPAND_FILL
		get_node("../Top").visible = false
		get_node("../../../../Rows").visible = false
		get_node("../ButtonList").visible = false
