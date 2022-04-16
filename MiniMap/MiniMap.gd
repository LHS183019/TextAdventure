extends Node2D

var cur_cam:Camera2D
var is_dragging # check if user is pressing LeftMouseButton
var can_drag # check if user is in the stage that allows MiniMap input

func initialize(rooms):
	$MapUI.initialize(rooms)
	can_drag = false
	Event.connect("map_exploration_change",self,"_handle_explore")


func _input(event: InputEvent) -> void:
	is_dragging = Input.is_mouse_button_pressed(BUTTON_LEFT) 
	var cur_cam_pos = cur_cam.get_node("../")
	if event is InputEventMouseButton: # handle the scaling
		if event.is_pressed() and can_drag:
			if event.button_index == BUTTON_WHEEL_UP and cur_cam.zoom >= Vector2(0.5,0.5): # limit the zoom value not be too close
				cur_cam.zoom -= Vector2(0.1,0.1)
			if event.button_index == BUTTON_WHEEL_DOWN and cur_cam.zoom <= Vector2(2,2): # limit the zoom value not be too far
				cur_cam.zoom += Vector2(0.1,0.1)
	if event is InputEventMouseMotion: #handle the dragging
		if is_dragging and can_drag:
			cur_cam_pos.global_position -= event.relative * cur_cam.zoom


func _handle_explore(exploring):
	if exploring:
		can_drag = true
	else:
		can_drag = false


func _on_ExploreMapBtn_mouse_entered() -> void:
	can_drag = false

func _on_ExploreMapBtn_mouse_exited() -> void:
	can_drag = true


func _on_CurrentPosBtn_pressed() -> void:
	var cur_cam_pos = cur_cam.get_node("../")
	cur_cam_pos.global_position = cur_cam_pos.get_node("../CharacterPosition").global_position
