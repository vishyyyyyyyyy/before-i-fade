extends Area2D

@export var normal_texture: Texture2D
@export var hover_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	sprite.texture = normal_texture

func _on_menu_banner_mouse_entered() -> void:
	sprite.texture = hover_texture
	print("HOVER ENTERED")

func _on_menu_banner_mouse_exited() -> void:
		sprite.texture = normal_texture
