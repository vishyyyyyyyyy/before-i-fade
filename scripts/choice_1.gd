extends Area2D

@export var normal_texture: Texture2D
@export var hover_texture: Texture2D

@onready var sprite: Sprite2D = $Menubanner

signal choice

func _on_mouse_entered():
	sprite.texture = hover_texture

func _on_mouse_exited():
	sprite.texture = normal_texture

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		
		viewport.set_input_as_handled()
		
		$"../ghosttext5/Label6".visible = false
		
		print("choice 1 clicked")
		emit_signal("choice")
