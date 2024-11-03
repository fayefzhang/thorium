extends AudioStreamPlayer

var lower_bound = 5.0
var upper_bound = 10.0

@onready var mc = $"../"
@onready var goop = $"../../Goop"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var strings = clamp(((mc.position.y - goop.position.y) - lower_bound)/(upper_bound - lower_bound), 0, 1)
	var rock = 1.0 - strings
	#print(mc.position.y - goop.position.y)
	stream.set_sync_stream_volume(0, -40 + strings*40)
	stream.set_sync_stream_volume(1, -40 + rock*40)
