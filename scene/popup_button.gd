extends Button

@export var node: Control

func _on_pressed() -> void:
	if node.visible == false:
		node.visible = true
	elif node.visible == true:
		node.visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
