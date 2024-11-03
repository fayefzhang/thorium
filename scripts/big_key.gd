extends Interactable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func canInteract(character: main_character) -> bool:
	return character.is_on_floor()

func interactText(character: main_character) -> String:
	return "Grab BIG KEY"

func interact(character: main_character) -> void:
	character.walkAnimation = "run-key"
	character.climbAnimation = "climb-key"
	character.hasBigKey = true
	set_collision_layer_value(2, false)
	set_collision_mask_value(2, false)
	$Sprite3D.visible = false
