extends Control

@onready var keys = $HBoxContainer.get_children()
var numKeys: int = 0

func _ready() -> void:
	for i in keys:
		if i.get_node("Key").visible:
			numKeys += 1

func useKey():
	for i in range(keys.size() - 1, -1, -1):
		if keys[i].get_node("Key").visible:
			keys[i].get_node("Key").visible = false
			break
	
