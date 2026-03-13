extends Area2D

var current_color = "green"
signal color_changed(tile_name: String, color: String)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:

		if current_color == "green":
			current_color = "white"
			$greentile.modulate = Color(1,1,1,1)

		else:
			current_color = "green"
			$greentile.modulate = Color(0.863, 1.0, 0.729)

		emit_signal("color_changed", name, current_color)
