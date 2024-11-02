extends CharacterBody3D

class_name main_character

@export var character_name:String
@export var texture:Texture2D
var rotateTime: float = 0.3

var facing: int = -1
var normalKeys: int = 0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var interactionObject: Interactable = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	normalKeys = $Keys.numKeys
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
		var localVel = velocity * transform.basis
		if localVel.x < 0 and facing == 1:
			var rotateTween: Tween = $rotateSprite.create_tween()
			rotateTween.tween_property($rotateSprite, "rotation_degrees:y", 0, rotateTime)
			facing = -1
		if localVel.x > 0 and facing == -1:
			var rotateTween: Tween = $rotateSprite.create_tween()
			rotateTween.tween_property($rotateSprite, "rotation_degrees:y", 180, rotateTime)
			facing = 1
		$rotateSprite/AnimatedSprite3D.play("run")
	else:
		velocity.x = 0
		velocity.z = 0
		$rotateSprite/AnimatedSprite3D.play("idle")
	
	if Input.is_action_just_pressed("interact") and interactionObject != null:
		interactionObject.interact(self)
	move_and_slide()

func _on_interactions_area_entered(area: Area3D) -> void:
	if area is Interactable and area.canInteract(self):
		$interactText.visible = true
		$interactText.text = area.interactText()
		interactionObject = area

func _on_interactions_area_exited(area: Area3D) -> void:
	$interactText.visible = false
	interactionObject = null

func useKey() -> void:
	if (normalKeys > 0):
		normalKeys -= 1
		$Keys.useKey();
		
func kill() -> void:
	# TODO: PLACEHOLDER => FINISH KILL FUNCTION
	print("PLAYER DIED: GAME OVER")
