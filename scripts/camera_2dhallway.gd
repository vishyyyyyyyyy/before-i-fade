extends Camera2D

var shake_strength: float = 0.0
var shake_timer: float = 0.0

@onready var player_layer = $".."
@onready var furniture = $"../../CanvasLayer3"

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		var shake_offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		offset = shake_offset
		player_layer.offset = shake_offset
		furniture.offset = shake_offset
	else:
		offset = Vector2.ZERO
		player_layer.offset = Vector2.ZERO
		furniture.offset = Vector2.ZERO


func shake(strength: float, duration: float):
	shake_strength = strength
	shake_timer = duration
