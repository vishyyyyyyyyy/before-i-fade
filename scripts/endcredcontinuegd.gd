extends Area2D
@export var normal_texture: Texture2D
@export var hover_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

signal pressed 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _on_mouse_entered():
	sprite.texture = hover_texture
	print("hover works")
	
func _on_mouse_exited():
	sprite.texture = normal_texture
	print("exited")
	
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		$".".visible=false
		$CollisionShape2D.disabled=true
		emit_signal("pressed")
