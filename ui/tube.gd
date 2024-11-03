extends Control

# tube values
var min_x: float = 89.844
var max_x: float = 0.781
var min_y: float = 679.688
var max_y: float = 4.688
@onready var liquid_node = $"Center/Tube-bg/Tube-liquid"

# goop values
@onready var goop = $"../Goop"
@onready var goop_min_y = goop.position.y
var goop_max_growth = 70.0

# mc icon values
var icon_min_x: float = 117.188
var icon_max_x: float = 26.563
var icon_min_y: float = 359.375
var icon_max_y: float = -362.5
@onready var mc = $"../MainCharacter"
@onready var mc_icon = $"Center/Tube-bg/mc-icon"

func set_fill_percentage(percentage: float) -> void:
	var fill_percentage = clamp(percentage, 0.0, 1.0)
	var new_x = lerp(min_x, max_x, fill_percentage)
	var new_y = lerp(min_y, max_y, fill_percentage)
	liquid_node.position.x = new_x
	liquid_node.position.y = new_y

func set_mc_icon(percentage: float) -> void:
	var mc_icon_height = clamp(percentage, 0.0, 1.0)
	var new_x = lerp(icon_min_x, icon_max_x, mc_icon_height)
	var new_y = lerp(icon_min_y, icon_max_y, mc_icon_height)
	mc_icon.position.x = new_x
	mc_icon.position.y = new_y

func _process(delta: float) -> void:
	var fill_percentage = (goop.position.y - goop_min_y) / goop_max_growth
	set_fill_percentage(fill_percentage)

	var mc_icon_height = (mc.position.y - goop_min_y) / goop_max_growth
	set_mc_icon(mc_icon_height)
