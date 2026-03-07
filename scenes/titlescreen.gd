extends Node2D

func _ready():
	$"title image/AnimationPlayer".play("animate")
	$"title image/AnimationPlayer2".play("modulate")
	await get_tree().create_timer(5).timeout
	$"title image/AnimationPlayer3".play("new_animation")
	await $"title image/AnimationPlayer3".animation_finished
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
