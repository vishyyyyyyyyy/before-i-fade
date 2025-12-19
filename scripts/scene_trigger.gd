extends Area2D

@export var target_scene: String
@export var requires_interaction: bool = false
@export var interaction_action: String = "interact"

var player_inside := false

func _ready():
	input_pickable = true

func _on_body_entered(body):
	if body is CharacterBody2D:
		if requires_interaction:
			player_inside = true
		else:
			change_scene()

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_inside = false

func _input_event(viewport, event, shape_idx):
	if requires_interaction and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			change_scene()
			
func change_scene():
	if target_scene != "":
		get_tree().change_scene_to_file(target_scene)
