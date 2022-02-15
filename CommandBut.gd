extends Button


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var input = get_owner().get_node("BackGround/MarginContainer/HBoxContainer/Rows/InputArea/HBoxContainer/Input")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_CommandButton_pressed() -> void:
	input.text = text + " " + input.text
	input.grab_focus()
	input.caret_position = input.text.length()
