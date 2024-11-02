extends Area3D

var isRising: bool = false
var riseRate: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rise(3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isRising:
		position.y += riseRate * delta

# rate is in m/s
func rise(rate: float) -> void:
	riseRate = rate
	isRising = true

func pause() -> void:
	isRising = false
	
func start() -> void:
	isRising = true

func _on_body_entered(body: Node3D) -> void:
	if body is main_character:
		body.kill()
		pause()
	pass # Replace with function body.
