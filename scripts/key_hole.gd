extends Interactable

class_name keyHole

# whether the key has been used
var keyUsed: bool = false
# time needed to use key in seconds
var useKeyTime: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func canInteract(character: main_character) -> bool:
	return character.normalKeys > 0

func interactText(character: main_character) -> String:
	return "Use Key"

func interact(character: main_character) -> void:
	character.useKey(useKeyTime)
	set_collision_layer_value(2, false)
