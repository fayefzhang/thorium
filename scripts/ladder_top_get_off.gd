extends Interactable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func canInteract(character: main_character) -> bool:
	return character.isClimbing

func interactText(character: main_character) -> String:
	if character.isClimbing:
		return "Get Up"
	return "ERROR"

func interact(character: main_character) -> void:
	if character.isClimbing:
		character.endClimbTop($Marker3D.global_position, $Marker3D.global_position.y)
