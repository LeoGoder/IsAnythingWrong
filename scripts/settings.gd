extends CanvasLayer

@export var soundSlider: Slider
@export var fullscreenButton: CheckBox
@export var resolutionOption: OptionButton
@export var applyButton: Button
@export var volumeLabel: Label
@export var canvas: CanvasLayer
var resolutions = [Vector2(1280, 720), Vector2(1366, 768), Vector2(1600, 900), Vector2(1920, 1080), Vector2(3440, 1440)]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	var value = AudioServer.get_bus_volume_db(bus_idx)
	var linear_volume = db_to_linear(value)

	soundSlider.value = linear_volume
	volumeLabel.text = str(round(linear_volume * 100)) + "%"

	for res in resolutions:
		var res_text = str(int(res.x)) + " x " + str(int(res.y))
		resolutionOption.add_item(res_text)

	var current_res = DisplayServer.window_get_size()
	for i in range(resolutions.size()):
		if resolutions[i] == Vector2(current_res):
			resolutionOption.selected = i
			break

	fullscreenButton.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	soundSlider.connect("value_changed", self._on_volume_slider_value_changed)

func _on_volume_slider_value_changed(value):
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
	volumeLabel.text = str(round(value * 100)) + "%"
	
func _on_apply_pressed() -> void:
	var res_index = resolutionOption.selected
	var res_to_change = resolutions[res_index]
	
	DisplayServer.window_set_size(res_to_change)
	get_tree().root.size = res_to_change
	if fullscreenButton.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_return_pressed() -> void:
	canvas.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
