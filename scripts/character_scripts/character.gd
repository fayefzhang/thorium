extends CharacterBody3D

class_name Character

@export var character_name:String
@export var texture:Texture2D
@export var isPlayer:bool
var cam:Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam = get_viewport().get_camera_3d()
	look_at(Vector3(cam.global_position.x, global_position.y, cam.global_position.z),Vector3.UP,true)
	if isPlayer:
		cam.top_level = false #to make cam move with player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !isPlayer:
		look_at(Vector3(cam.global_position.x, global_position.y, cam.global_position.z),Vector3.UP,true)
