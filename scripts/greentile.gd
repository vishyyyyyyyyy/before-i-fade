extends Area2D

var counter =0 
signal color_changed(tile_name: String, color: String)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		counter += 1
		var color = ""
		if counter % 2 == 1:
			$greentile.modulate = Color(1,1,1,1)
			color = "white"
		else:
			$greentile.modulate = Color(0.863, 1.0, 0.729)
			color = "green"
		emit_signal("color_changed", name, color)  # `name` is the node name, e.g., "tile1"
