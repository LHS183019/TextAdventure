extends PanelContainer


export(int) var max_lines_remembered := 30

signal create_finish()

const Units = preload("res://global/Units.tres")
const InputRespone = preload("res://input/InputResponse.tscn")
onready var history_rows = $ScrollContainer/HistoryRows
onready var scroll = $ScrollContainer
onready var scroll_bar = scroll.get_v_scrollbar()

var max_scroll_value := 0

func _ready() -> void:
	Units.game_info = self
	scroll_bar.connect("changed",self,"_handle_scrollbar_change")
	max_scroll_value = scroll_bar.max_value
	

func create_response(response_text,input_text=""):
	if input_text.empty():
		_add_response_to_historyrows(response_text)
	else:
		_add_history_to_historyrows(input_text,response_text)
	_delete_history_beyond_limit()

func _add_history_to_historyrows(input_text:String,response_text:String):
	var history_row = InputRespone.instance()
	history_row.set_text(input_text, response_text)
	history_rows.add_child(history_row)
	emit_signal("create_finish")

func _add_response_to_historyrows(response_text:String):
	var response_row = InputRespone.instance()
	response_row.set_text("",response_text)
	history_rows.add_child(response_row)
	emit_signal("create_finish")
	
func _delete_history_beyond_limit():
	if history_rows.get_child_count() > max_lines_remembered:
		var numbers_to_forget = history_rows.get_child_count() - max_lines_remembered
		for i in range(numbers_to_forget):
			history_rows.get_child(i).queue_free()

func _handle_scrollbar_change():
	if max_scroll_value != scroll_bar.max_value:
		max_scroll_value = scroll_bar.max_value
		scroll.scroll_vertical = scroll_bar.max_value
