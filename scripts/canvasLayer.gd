extends CanvasLayer

@onready var inventoryGui = $InventoryGUI

func _input(event):
	if event.is_action_pressed("toggleInventory"):
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
