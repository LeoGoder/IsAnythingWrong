extends Node2D

var hour_unit = 5
var hour_ten = 0
var minute_unit = 0
var minute_ten = 0
var salon_item_position = []
var salon_player_item_position
@onready var time = $"../CanvasLayer/Label"
@onready var timer = $"../Timer"
@onready var salon = get_node("/root/map/salon")


func _on_timer_timeout() -> void:
	minute_unit = minute_unit + 1
	if minute_unit >= 10:
		minute_ten += 1
		minute_unit = 0
	if minute_ten >= 5:
		hour_unit += 1
		minute_ten = 0
	if hour_unit >= 6:
		get_tree().change_scene_to_file("res://scene/VictoryScreen.tscn")
	display_time()

func display_time():
	time.text = str(hour_ten) + str(hour_unit) + " : " + str(minute_ten) + str(minute_unit)
	
func object_based_list():
	if salon:
		for child in salon.get_children():
			salon_item_position.append(child.position)

func player_erease_anomalies():
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_time()
	object_based_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
