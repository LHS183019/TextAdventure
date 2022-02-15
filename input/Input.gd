extends LineEdit


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var input_history = []
var current_index = 0
var max_index = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grab_focus()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() and event.scancode == KEY_DOWN:
			if current_index+1 <= input_history.size()-1:
				current_index += 1
				text = input_history[current_index]
		if event.is_pressed() and event.scancode == KEY_UP:
			if current_index-1 >= 0:
				current_index -= 1
				text = input_history[current_index]

func _on_Input_text_entered(new_text: String) -> void:
	if !new_text.empty():
		input_history[max_index] = new_text
		max_index += 1
	if input_history.size() >= 10:
		input_history.pop_front()
		max_index -= 1
	
	current_index = max_index
	
	clear()


func _on_Input_text_changed(new_text: String) -> void:
	if input_history.size() <= max_index:
		input_history.append("")
	input_history[max_index] = new_text
