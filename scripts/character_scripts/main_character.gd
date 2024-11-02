extends CharacterBody3D

class_name main_character

@export var character_name:String
@export var texture:Texture2D
var cam:Camera3D
var rotateTime: float = 0.3

var facing: int = -1;

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam = get_viewport().get_camera_3d()
	look_at(Vector3(cam.global_position.x, global_position.y, cam.global_position.z),Vector3.UP,true)

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if velocity.x > 0 and facing == 1:
			var rotateTween: Tween = $rotateSprite.create_tween()
			rotateTween.tween_property($rotateSprite, "rotation_degrees:y", 0, rotateTime)
			facing = -1
		if velocity.x < 0 and facing == -1:
			var rotateTween: Tween = $rotateSprite.create_tween()
			rotateTween.tween_property($rotateSprite, "rotation_degrees:y", 180, rotateTime)
			facing = 1
		$rotateSprite/AnimatedSprite3D.play("run")
	else:
		velocity.x = 0
		velocity.z = 0
		$rotateSprite/AnimatedSprite3D.play("idle")

	move_and_slide()
