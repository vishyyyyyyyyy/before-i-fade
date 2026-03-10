extends Camera2D

var shake_strength: float = 0.0
var shake_timer: float = 0.0


func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		var shake_offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		offset = shake_offset
	else:
		offset = Vector2.ZERO


func shake(strength: float, duration: float):
	shake_strength = strength
	shake_timer = duration
