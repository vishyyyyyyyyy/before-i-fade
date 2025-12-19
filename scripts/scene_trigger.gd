extends Area2D

@export var choose: String = "res://scenes/choosechar.tscn"

func _ready():
	pass

func _on_body_entered(body):
	if body is CharacterBody2D:
		get_tree().change_scene_to_file(choose)
		print("player entered")
