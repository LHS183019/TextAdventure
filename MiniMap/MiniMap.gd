extends Node2D

var cur_cam:Camera2D
var is_dragging # check if user is pressing LeftMouseButton
var can_drag # check if user is in the stage that allows MiniMap input
var init_windows_size:Vector2
var ratio = 1
var map_exploring
var map_scale

func initialize(rooms):
	$MapUI.initialize(rooms)
	can_drag = false
	Event.connect("map_exploration_change",self,"_handle_explore")
	get_viewport().connect("size_changed",self,"_handle_windows_size_change")
	init_windows_size = Vector2(970, 546)
	map_exploring = 0
	map_scale = 0

func _input(event: InputEvent) -> void:
	is_dragging = Input.is_mouse_button_pressed(BUTTON_LEFT) 
	var cur_cam_pos = cur_cam.get_node("../")
	if event is InputEventMouseButton: # handle the scaling
		if event.is_pressed() and can_drag:
			if event.button_index == BUTTON_WHEEL_UP and cur_cam.zoom >= Vector2(0.6*ratio,0.6*ratio): # limit the zoom value not be too close
				cur_cam.zoom -= Vector2(0.1*ratio,0.1*ratio)
				map_scale -= 0.1
			if event.button_index == BUTTON_WHEEL_DOWN and cur_cam.zoom <= Vector2(1.95*ratio,1.95*ratio): # limit the zoom value not be too far
				cur_cam.zoom += Vector2(0.1*ratio,0.1*ratio)
				map_scale += 0.1
	if event is InputEventMouseMotion: #handle the dragging
		if is_dragging and can_drag:
			cur_cam_pos.global_position -= event.relative * cur_cam.zoom

func _handle_windows_size_change():
	var cur_windows_size = get_viewport().size
	var ratio_x = init_windows_size.x / cur_windows_size.x
	var ratio_y = init_windows_size.y / cur_windows_size.y
	ratio = min(ratio_x, ratio_y)
	if map_exploring >= 1:
		print(map_scale)
		cur_cam.zoom.x = (1.5 + map_scale)*ratio
		cur_cam.zoom.y = (1.5 + map_scale)*ratio

func _handle_explore(exploring):
	if exploring:
		can_drag = true
		map_exploring += 1
	else:
		can_drag = false
		map_exploring -= 1


func _on_ExploreMapBtn_mouse_entered() -> void:
	can_drag = false

func _on_ExploreMapBtn_mouse_exited() -> void:
	can_drag = true


func _on_CurrentPosBtn_pressed() -> void:
	var cur_cam_pos = cur_cam.get_node("../")
	cur_cam_pos.global_position = cur_cam_pos.get_node("../CharacterPosition").global_position
