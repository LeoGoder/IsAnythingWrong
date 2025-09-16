extends CanvasLayer

@onready var quit = $VBoxContainer/Quit
@export var time: Timer
@export var player_script: Node2D


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_resume_pressed() -> void:
	if self.visible == true:
		self.visible = false
		time.paused = false
		player_script.can_move = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
