extends CharacterBody3D

class_name main_character

signal playerWin

@export var character_name:String
@export var texture:Texture2D
var rotateTime: float = 0.3
var noInput: bool = false

# climbing vars
var isClimbing: bool = false
var canContinueClimbingUp: bool = true
const CLIMB_SPEED: float = 5.0
var zOffset: Vector3

var hasBigKey = false

#animation names
var walkAnimation: String = "run"
var climbAnimation: String = "climb"
var turnKeyAnimation: String = "turn-key"

var facing: int = -1
var normalKeys: int = 0

const SPEED = 5.0
const JUMP_VELOCITY = 5.0
var interactionObject: Interactable = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	normalKeys = $Keys.numKeys
	$GameOver.visible = false
	$WinScreen.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _physics_process(delta):
	velocity.x = 0
	velocity.z = 0
	
	if noInput:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# climbing movement
	if isClimbing:
		velocity.y = 0
		var movement: Vector2 = Input.get_vector("left", "right", "up", "down")
		var xMovement: float = movement.x
		var yMovement: float = movement.y
		#end climb animation
		if is_on_floor():# and movement.x != 0 and movement.y == 0:
			$interactText.visible = true
			$interactText.text = "Get Down"
			if Input.is_action_just_pressed("interact"):
				endClimbBottom()
				return
		else:
			$interactText.visible = false
		if yMovement == 0: # pause animation when still
			$rotateSprite/AnimatedSprite3D.pause()
		elif canContinueClimbingUp or yMovement < 0: # animation when moving

			$rotateSprite/AnimatedSprite3D.play()
			velocity.y = -(yMovement / abs(yMovement)) * CLIMB_SPEED
		if Input.is_action_just_pressed("interact") and interactionObject != null:
			interactionObject.interact(self)
		move_and_slide()
		return
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
		$rotateSprite/AnimatedSprite3D.play(walkAnimation)
	else:
		$rotateSprite/AnimatedSprite3D.play("idle")
	
	if Input.is_action_just_pressed("interact") and interactionObject != null:
		interactionObject.interact(self)
	move_and_slide()

func _on_interactions_area_entered(area: Area3D) -> void:
	if area is Interactable and area.canInteract(self):
		$interactText.visible = true
		$interactText.text = area.interactText(self)
		interactionObject = area

func _on_interactions_area_exited(area: Area3D) -> void:
	$interactText.visible = false
	interactionObject = null

func useKey(time: float) -> void:
	if (normalKeys > 0):
		normalKeys -= 1
		$Keys.useKey()
		$use_key.play()
		var turnKeyTween: Tween = create_tween()
		noInput = true
		$rotateSprite/AnimatedSprite3D.play(turnKeyAnimation)
		turnKeyTween.tween_callback(finishAnimation).set_delay(time)

func finishAnimation() -> void:
	noInput = false
	$rotateSprite/AnimatedSprite3D.play("idle")

func kill() -> void:
	$Keys.visible = false
	$GameOver.visible = true
	noInput = true
	print("PLAYER DIED: GAME OVER")

func startClimb(offsetZ: Vector3) -> void:
	set_collision_layer_value(3, true)
	set_collision_mask_value(3, true)
	isClimbing = true
	canContinueClimbingUp = true
	noInput = true
	zOffset = offsetZ
	$rotateSprite/AnimatedSprite3D.play("idle")
	$rotateSprite/AnimatedSprite3D.pause()
	var climbTween: Tween = create_tween()
	climbingTweenHelper(climbTween)
	climbTween.tween_callback(func():
		$rotateSprite/AnimatedSprite3D.play(climbAnimation)
		$rotateSprite/AnimatedSprite3D.pause()
		noInput = false
	)

func endClimbBottom() -> void:
	set_collision_layer_value(3, false)
	isClimbing = false
	# TODO: fix bug where you have to leave and come back to be able to climb again
	$interactText.visible = false
	noInput = true
	zOffset.y = position.y
	create_tween().tween_property(self, "position", zOffset, rotateTime)
	var climbTween: Tween = create_tween()
	climbingTweenHelper(climbTween)
	climbTween.tween_callback(func():
		$rotateSprite/AnimatedSprite3D.play("idle")
		noInput = false
	)

func endClimbTop(posXZ: Vector3, posY: float) -> void:
	set_collision_layer_value(3, false)
	isClimbing = false
	noInput = true
	var climbToTopTween = create_tween()
	climbToTopTween.tween_property(self, "position:y", posY + $Interactions/interactionCollider.shape.height/2, rotateTime)
	climbToTopTween.tween_callback(func(): climbingTweenHelper(create_tween()))
	climbToTopTween.tween_callback(func(): 
		clampToLadderXZDirs(posXZ)
		noInput = false
		)

func climbingTweenHelper(climbTween: Tween):
	if facing == -1:
		climbTween.tween_property($rotateSprite, "rotation_degrees:y", 180, rotateTime)
		facing = 1
	else:
		climbTween.tween_property($rotateSprite, "rotation_degrees:y", 0, rotateTime)
		facing = -1

func clampToLadderXZDirs(pos: Vector3):
	pos.y = position.y
	create_tween().tween_property(self, "position", pos, rotateTime)



func _on_button_button_down() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.

func win() -> void:
	noInput = true
	$WinScreen.visible = true
