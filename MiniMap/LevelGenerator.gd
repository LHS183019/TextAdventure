extends Node

const Level = preload("res://MiniMap/MiniMapLevel.tscn")
onready var RoomControl = $"../RoomControl"

# generate a new level and add it to the RoomControl
# named it as Level_x
# return the generated level
func generate(level:int):
	if !RoomControl.has_node("Level_%d"%level):
		var new_level = Level.instance()
		new_level.name = "Level_%d" % level
		new_level.position = Vector2(500,500)
		RoomControl.add_child(new_level)
		return new_level
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
