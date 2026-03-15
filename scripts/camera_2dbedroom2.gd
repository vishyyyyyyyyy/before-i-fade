extends Camera2D

var shake_strength: float = 0.0
var shake_timer: float = 0.0

@onready var player_layer = $".."
@onready var furniture = [$"../../CanvasModulate/Desk", $"../../CanvasModulate/Bed", $"../../CanvasModulate/Safe", $"../../CanvasModulate/Window", $"../../CanvasModulate/Calendar", $"../../CanvasModulate/Calendar2"]

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		var shake_offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		offset = shake_offset
		player_layer.offset = shake_offset
		for item in furniture:
			item.offset = shake_offset
	else:
		offset = Vector2.ZERO
		player_layer.offset = Vector2.ZERO
	for item in furniture:
		item.offset = Vector2.ZERO


func shake(strength: float, duration: float):
	shake_strength = strength
	shake_timer = duration
