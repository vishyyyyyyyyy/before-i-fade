extends Area2D

@export var normal_texture: Texture2D
@export var hover_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

signal play

func _ready():
	sprite.texture = normal_texture
	input_pickable = true

func _on_mouse_entered():
	sprite.texture = hover_texture
	print("hover works")
	
func _on_mouse_exited():
	sprite.texture = normal_texture
	print("exited")
	
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("play")

#@export var normal_texture: Texture2D
#@export var hover_texture: Texture2D
#
#@onready var sprite: Sprite2D = $Sprite2D
#
#signal play
#
#func _ready():
	#sprite.texture = normal_texture
	#input_pickable = true
#
#func _on_mouse_entered():
	#sprite.texture = hover_texture
#
#func _on_mouse_exited():
	#sprite.texture = normal_texture
#
#func _input_event(viewport, event, shape_idx):
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#print("clicked!")  # For debugging
		#emit_signal("play")
