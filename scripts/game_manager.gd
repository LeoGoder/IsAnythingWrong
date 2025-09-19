extends Node2D

var hour_unit = 0
var hour_ten = 0
var minute_unit = 0
var minute_ten = 0
var salon_based_item = []
var salon_item_manipulate = []
var salon_player_item_position
var number_anomalies = 0
var index_of_anomalies = 0
@onready var time = $"../CanvasLayer/Label"
@onready var timer = $"../Timer"
#@onready var salon = get_node("/root/map/salon")
@export var salon: Sprite2D
@export var checking: Timer
@export var check_text: Label
@export var books: AnimatedSprite2D

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

func create_anomalies():
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(0, salon.get_child_count() - 1)
	var item_manipulate = salon_item_manipulate[random_number]
	var item_compare = salon_based_item[random_number]
	
	if item_manipulate.name == "Carpet" && item_manipulate.position == item_compare.position:
		item_manipulate.rotation -= deg_to_rad(90)
		item_manipulate.position.x = 299
		number_anomalies += 1
	if item_manipulate.name == "Books" || item_manipulate.name == "Mouse":
		if item_manipulate.position == item_compare.position:
			item_manipulate.position.x += 50
			number_anomalies += 1
	if item_manipulate.name == "MakeYouSmile":
		if item_manipulate.visible == false:
			item_manipulate.visible = true
			number_anomalies += 1

func _on_spawn_anomalie_timeout() -> void:
	create_anomalies()

func object_based_list():
	if salon:
		for child in salon.get_children():
			salon_based_item.append(child.duplicate())
			salon_item_manipulate.append(child)


func _on_checking_timeout() -> void:
	if salon_item_manipulate[index_of_anomalies].name == "Books" || salon_item_manipulate[index_of_anomalies].name == "Mouse":
		salon_item_manipulate[index_of_anomalies].position = salon_based_item[index_of_anomalies].position
		number_anomalies -= 1
	if salon_item_manipulate[index_of_anomalies].name == "Carpet":
		salon_item_manipulate[index_of_anomalies].position = salon_based_item[index_of_anomalies].position
		salon_item_manipulate[index_of_anomalies].rotation = salon_based_item[index_of_anomalies].rotation
		number_anomalies -= 1
	if salon_item_manipulate[index_of_anomalies].name == "MakeYouSmile":
		salon_item_manipulate[index_of_anomalies].visible = false
		number_anomalies -= 1
	
	check_text.visible = false

# will check for anomalies in the salon
func _on_salon_pressed() -> void:
	for i in range(salon.get_child_count()):
		if salon_item_manipulate[i].position != salon_based_item[i].position:
			checking.start()
			check_text.visible = true
			index_of_anomalies = i
		elif salon_item_manipulate[i].name == "MakeYouSmile" && salon_item_manipulate[i].visible == true:
			print("je souris")
			checking.start()
			check_text.visible = true
			index_of_anomalies = i

func is_there_too_anomalies():
	if number_anomalies == 4:
		pass
	if number_anomalies >= 6:
		get_tree().change_scene_to_file("res://scene/GameOver.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_time()
	object_based_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	is_there_too_anomalies()
