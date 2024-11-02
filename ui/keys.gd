extends Control

@onready var keys = $HBoxContainer.get_children()

func useKey():
	for i in range(keys.size() - 1, -1, -1):
		if keys[i].get_node("Item").visible:
			keys[i].get_node("Item").visible = false
			break
