extends Area2D
signal char_chosen

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
	
var selected_character := ""

func _on_girl_pressed() -> void:
	if selected_character == "girl":
		Global.character = "girlGhost"
		Global.pastChar = "pastGirl"
		emit_signal("char_chosen")
	else:
		selected_character = "girl"
		$"../BoyGhost".visible = false
		$"../GirlGhost".visible = true
