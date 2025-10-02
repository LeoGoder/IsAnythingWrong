extends CanvasLayer

@onready var quit = $VBoxContainer/Quit
@export var time: Timer
@export var player_script: Node2D
@export var confirmation: Control
@export var settings: CanvasLayer
@export var gamemanager_script: Node2D


func _on_quit_pressed() -> void:
	confirmation.visible = true

func _on_resume_pressed() -> void:
	if self.visible == true:
		self.visible = false
		time.paused = false
		player_script.can_move = true
		gamemanager_script.anomalies_can_spawn = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_confirm_pressed() -> void:
	get_tree().quit()


func _on_cancel_pressed() -> void:
	confirmation.visible = false


func _on_settings_pressed() -> void:
	settings.visible = true
