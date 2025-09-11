extends Button

@export var salon: Button

func _on_pressed() -> void:
	if salon.visible == false:
		salon.visible = true
	elif salon.visible == true:
		salon.visible = false

func _on_salon_pressed() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
