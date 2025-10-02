extends Node2D

class_name GameManager 

var hour_unit = 0
var hour_ten = 0
var minute_unit = 0
var minute_ten = 0
var salon_based_item = []
var cuisine_based_item = []
var couloir_based_item = []
var toilet_based_item = []
var salon_item_manipulate = []
var cuisine_item_manipulate = []
var couloir_item_manipulate = []
var toilet_item_manipulate = []
var number_anomalies = 0
var index_of_anomalies = 0
var anomalies_can_spawn = true
var void_scale = Vector2(0.0, 0.0)
@export var the_void: Sprite2D
@onready var time = $"../CanvasLayer/Label"
@onready var timer = $"../Timer"
@export var salon: Sprite2D
@export var cuisine: Sprite2D
@export var couloir: Sprite2D
@export var toilet: Sprite2D
@export var report_button: Button
@export var checking: Timer
@export var check_text: Label
@export var hourly_alarme: AudioStreamPlayer
@export var books: AnimatedSprite2D
@export var popup_report: Control
@export var poubelle: Sprite2D
var poubelle_rotation = deg_to_rad(0)
@export var the_player: Node2D
@onready var block_view = the_player.get_node("Camera2D/CanvasLayer/Block_view")

func _on_timer_timeout() -> void:
	minute_unit = minute_unit + 1
	if minute_unit >= 10:
		minute_ten += 1
		minute_unit = 0
	if minute_ten >= 6:
		hour_unit += 1
		hourly_alarme.play()
		minute_ten = 0
	if hour_unit >= 3:
		get_tree().change_scene_to_file("res://scene/VictoryScreen.tscn")
	display_time()
	

func display_time():
	time.text = str(hour_ten) + str(hour_unit) + " : " + str(minute_ten) + str(minute_unit)

func anomalies_on_salon():
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

func anomalies_on_cuisine():
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(0, cuisine.get_child_count() - 1)
	var item_manipulate = cuisine_item_manipulate[random_number]
	var item_compare = cuisine_based_item[random_number]
	
	if (item_manipulate.name == "Light_oven" || item_manipulate.name == "EauLavabo") && item_manipulate.visible == false:
		item_manipulate.visible = true
		number_anomalies += 1
	if item_manipulate.name == "BadCoffee" && item_manipulate.visible == true:
		item_manipulate.visible = false
		number_anomalies += 1
	if item_manipulate.name == "Poubelle" && poubelle_rotation == 0:
		poubelle_rotation = deg_to_rad(2)
		number_anomalies += 1
	if item_manipulate.name == "Dead" && item_manipulate.visible == false:
		item_manipulate.visible = true
		number_anomalies += 1
	
func anomalies_on_couloir():
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(0, couloir.get_child_count() - 1)
	var item_manipulate = couloir_item_manipulate[random_number]
	var item_compare = couloir_based_item[random_number]

	if item_manipulate.name == "Void" && item_manipulate.visible == false && item_manipulate.scale == item_compare.scale:
		item_manipulate.visible = true
		number_anomalies += 1
		void_scale = Vector2(0.0001, 0.0001)
	if item_manipulate.name == "Ghost" && item_manipulate.visible == false:
		item_manipulate.visible = true
		number_anomalies += 1

func anomalies_on_toilet():
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(0, couloir.get_child_count() - 1)
	var item_manipulate = toilet_item_manipulate[random_number]
	var item_compare = toilet_based_item[random_number]

	if item_manipulate.name == "???" && item_manipulate.visible == false:
		item_manipulate.visible = true
		number_anomalies += 1


func create_anomalies():
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(0, 3)
	if random_number == 0:
		anomalies_on_salon()
	if random_number == 1:
		anomalies_on_cuisine()
	if random_number == 2:
		anomalies_on_couloir()
	if random_number == 3:
		anomalies_on_toilet()

func _on_spawn_anomalie_timeout() -> void:
	if anomalies_can_spawn == true:
		create_anomalies()

func object_based_list():
	if salon:
		for child in salon.get_children():
			salon_based_item.append(child.duplicate())
			salon_item_manipulate.append(child)
	if cuisine:
		for child in cuisine.get_children():
			cuisine_based_item.append(child.duplicate())
			cuisine_item_manipulate.append(child)
	if couloir:
		for child in couloir.get_children():
			couloir_based_item.append(child.duplicate())
			couloir_item_manipulate.append(child)
	if toilet:
		for child in toilet.get_children():
			toilet_based_item.append(child.duplicate())
			toilet_item_manipulate.append(child)

func _on_checking_timeout() -> void:
	report_button.disabled = false
	check_text.visible = false
	block_view.visible = false

func block_view_for_a_while():
	block_view.visible = true
	checking.start()
	check_text.visible = true
	report_button.disabled = true
	popup_report.visible = false

# will check for anomalies
func _on_salon_pressed() -> void:
	for i in range(salon.get_child_count()):
		if salon_item_manipulate[i].position != salon_based_item[i].position:
			salon_item_manipulate[i].position = salon_based_item[i].position
			salon_item_manipulate[i].rotation = salon_based_item[i].rotation
			number_anomalies -= 1
			break
		elif salon_item_manipulate[i].name == "MakeYouSmile" && salon_item_manipulate[i].visible == true:
			salon_item_manipulate[i].visible = false
			number_anomalies -= 1
			break
			
		else:
			pass
	block_view_for_a_while()

func _on_cuisne_pressed() -> void:
	for i in range(cuisine.get_child_count()):
		if (cuisine_item_manipulate[i].name == "Light_oven" || cuisine_item_manipulate[i].name == "EauLavabo") && cuisine_item_manipulate[i].visible == true:
			cuisine_item_manipulate[i].visible = false
			number_anomalies -= 1
			break
		elif cuisine_item_manipulate[i].name == "BadCoffee" && cuisine_item_manipulate[i].visible == false:
			cuisine_item_manipulate[i].visible = true
			number_anomalies -= 1
			break
		elif cuisine_item_manipulate[i].name == "Poubelle" && poubelle_rotation != 0:
			poubelle_rotation = deg_to_rad(0)
			cuisine_item_manipulate[i].rotation = deg_to_rad(0)
			number_anomalies -= 1
			break
		elif cuisine_item_manipulate[i].name == "Dead" && cuisine_item_manipulate[i].visible == true:
			cuisine_item_manipulate[i].visible = false
			number_anomalies -= 1
			break
	block_view_for_a_while()

func _on_couloir_pressed() -> void:
	for i in range(couloir.get_child_count()):
		if couloir_item_manipulate[i].name == "Void" && couloir_item_manipulate[i].visible == true:
			couloir_item_manipulate[i].visible = false
			couloir_item_manipulate[i].scale = Vector2(0,0)
			void_scale = Vector2(0,0)
			number_anomalies -= 1
			break
		elif couloir_item_manipulate[i].name == "Ghost" && couloir_item_manipulate[i].visible == true:
			couloir_item_manipulate[i].visible = false
			number_anomalies -= 1
			break
		
	block_view_for_a_while()


func _on_toilet_pressed() -> void:
	for i in range(toilet.get_child_count()):
		if toilet_item_manipulate[i].name == "???" && toilet_item_manipulate[i].visible == true:
			toilet_item_manipulate[i].visible = false
			number_anomalies -= 1
			break
		else:
			pass
	block_view_for_a_while()

func is_there_too_anomalies():
	if number_anomalies == 4:
		time.set("theme_override_colors/font_color", Color(1,0,0))
		check_text.set("theme_override_colors/font_color", Color(1,0,0))
		
	if number_anomalies >= 5:
		get_tree().change_scene_to_file("res://scene/GameOver.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_time()
	object_based_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	is_there_too_anomalies()
	poubelle.rotation += poubelle_rotation
	the_void.scale += void_scale
