extends Control

var min_x: float = 89.844
var max_x: float = 0.781
var min_y: float = 679.688
var max_y: float = 4.688

var fill_percentage: float = 0.0

@onready var liquid_node = $"Center/Tube-bg/Tube-liquid"

func set_fill_percentage(percentage: float) -> void:
	fill_percentage = clamp(percentage, 0.0, 100.0)
	var new_x = lerp(min_x, max_x, fill_percentage / 100.0)
	var new_y = lerp(min_y, max_y, fill_percentage / 100.0)
	liquid_node.position.x = new_x
	liquid_node.position.y = new_y

#func _process(delta: float) -> void:
	## Simulate filling the tube over time (remove if not needed)
	#fill_percentage += delta * 10.0
	#set_fill_percentage(fill_percentage)
