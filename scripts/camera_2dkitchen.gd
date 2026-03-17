extends Camera2D

var shake_strength := 0.0
var shake_timer := 0.0

@onready var world = $"../.." 
@onready var player = $".." 

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta

		var shake_offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)

		world.position = shake_offset
		player.offset = shake_offset
	else:
		world.position = Vector2.ZERO
		player.offset = Vector2.ZERO


func shake(strength: float, duration: float):
	shake_strength = strength
	shake_timer = duration
