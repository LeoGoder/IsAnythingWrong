extends Node2D

var cam_list_position = [Vector2(0, 0), Vector2(100, 20)]
var cam_index = 0
var can_move = true
@onready var cam = $Camera2D
@onready var pause = $"../Root"
@onready var console = get_node("/root/map/Root/Console_Window")
@onready var game_timer = get_node("/root/map/Timer")
@onready var spawn_timer = get_node("/root/map/Spawn_anomalie")

func next_camera():
	if Input.is_action_just_pressed("next") and can_move == true:
		cam_index += 1
		if cam_index >= 2: 
			cam_index = 0
			cam.position = cam_list_position[cam_index]
		else:
			cam.position = cam_list_position[cam_index]
	if Input.is_action_just_pressed("previous") and can_move == true:
		cam_index -= 1
		if cam_index < 0: 
			cam_index = 1
			cam.position = cam_list_position[cam_index]
		else:
			cam.position = cam_list_position[cam_index]

func enable_diable_settings():
	if Input.is_action_just_pressed("pause"):
		if pause.visible == true:
			pause.visible = false
			game_timer.paused = false
			can_move = true
		elif pause.visible == false:
			pause.visible = true
			game_timer.paused = true
			can_move = false

func enable_disable_console():
	if Input.is_action_just_pressed("console"):
		if console.visible == true:
			console.visible = false
		elif console.visible == false:
			console.visible = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	next_camera()
	enable_diable_settings()
	enable_disable_console()
