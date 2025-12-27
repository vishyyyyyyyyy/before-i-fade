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
	if not is_inside_tree():
		return

	if Global.kitchen == 5:
		get_tree().change_scene_to_file("res://scenes/hallway2.tscn")

	elif Global.livingroom == 1:
		get_tree().change_scene_to_file("res://scenes/kitchen2.tscn")

	elif Global.kitchen == 4:
		get_tree().change_scene_to_file("res://scenes/livingroom.tscn")

	elif Global.kitchen == 3:
		get_tree().change_scene_to_file("res://scenes/kitchen2.tscn")

	elif Global.reusablehallway == 4:
		get_tree().change_scene_to_file("res://scenes/hallway2.tscn")

	elif Global.reusablehallway == 3:
		get_tree().change_scene_to_file("res://scenes/bedroomdiaryentry2plus.tscn")

	elif Global.reusablehallway == 2 and Global.reusabledesk >= 2 and Global.kitchen == 2:
		get_tree().change_scene_to_file("res://scenes/hallway2.tscn")

	elif Global.reusablehallway == 1 and Global.reusabledesk >= 2 and Global.kitchen == 1:
		get_tree().change_scene_to_file("res://scenes/kitchen.tscn")

	elif Global.reusablehallway == 1 and Global.reusabledesk >= 2:
		get_tree().change_scene_to_file("res://scenes/hallway2.tscn")

	elif target_scene != "":
		get_tree().change_scene_to_file(target_scene)
