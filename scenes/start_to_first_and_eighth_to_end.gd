extends AudioStreamPlayer

var keys: int = 0
var keys_before: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	keys = $"../".normalKeys
	play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	keys = $"../".normalKeys
	print(keys)
	if (keys == 7):
		keys_before = $"../".normalKeys
		stop()
	if ((keys == 3) && !has_stream_playback()):
		play()
	if (keys == -1):
		stop()
	pass
