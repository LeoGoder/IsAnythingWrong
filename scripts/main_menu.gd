extends Control

var speed = 0.1
@export var camera: Camera2D

func move_camera_with_mouse():
	var mouse_position = get_global_mouse_position()
	camera.position = mouse_position * speed
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_camera_with_mouse()
