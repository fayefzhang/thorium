extends Area3D

class_name Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func canInteract(character: main_character) -> bool:
	return true

func interactText() -> String:
	return "PLACEHOLDER"

func interact(character: main_character) -> void:
	pass
