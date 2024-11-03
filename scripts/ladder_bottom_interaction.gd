extends Interactable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func canInteract(character: main_character) -> bool:
	return character.is_on_floor() and !character.isClimbing

func interactText(character: main_character) -> String:
	if character.is_on_floor() and !character.isClimbing:
		return "Climb"
	return "ERROR"

func interact(character: main_character) -> void:
	if character.is_on_floor() and !character.isClimbing:
		
		character.startClimb()
