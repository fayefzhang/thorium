extends StaticBody3D

var rotationTween: Tween = null
var timeForFullRotation: float = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startWithRotationTime(timeForFullRotation, 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start(direction: int) -> void:
	rotationTween = create_tween()
	rotationTween.tween_property(self, "rotation_degrees:z", direction * 360, timeForFullRotation)
	rotationTween.tween_property(self, "rotation_degrees:z", 0, 0)
	rotationTween.set_loops()

func startWithRotationTime(time: float, direction: int) -> void:
	timeForFullRotation = time
	start(direction)

func stop() -> void:
	rotationTween.kill()
