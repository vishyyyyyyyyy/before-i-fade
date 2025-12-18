extends Area2D

@export var normal_texture: Texture2D
@export var hover_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	sprite.texture = normal_texture
	input_pickable = true

func _on_mouse_entered():
	sprite.texture = hover_texture
	print("hover works")
	
func _on_mouse_exited():
	sprite.texture = normal_texture
	print("exited")
	

func _on_boy_pressed() -> void:
	Global.character = "boyGhost"
	get_tree().change_scene_to_file("res://scenes/blob_ghost_player.tscn")
	

func _on_girl_pressed() -> void:
	Global.character = "girlGhost"
	get_tree().change_scene_to_file("res://scenes/blob_ghost_player.tscn")
