extends Interactable

class_name keyHole

var keyUsed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func canInteract(character: main_character) -> bool:
	return character.normalKeys > 0

func interactText() -> String:
	return "Use Key"

func interact(character: main_character) -> void:
	character.useKey()
	set_collision_layer_value(2, false)
