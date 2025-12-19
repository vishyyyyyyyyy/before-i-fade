extends Area2D

@export var goBathroom: String = "res://scenes/bathroom.tscn"

func _ready():
	pass

func _on_body_entered(body):
	if body is CharacterBody2D:
		get_tree().change_scene_to_file(goBathroom)
		print("player entered")
