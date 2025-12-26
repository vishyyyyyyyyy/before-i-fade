extends Area2D

var counter =0 
signal box_changed(tile_name: String, color: String)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		#print("CLICKED:", name)
		counter += 1
		var box = ""
		if counter % 2 == 1:
			$Box.visible=false
			$Box2.visible=true
			box = "open"
		
		else:
			$Box.visible=true
			$Box2.visible=false
			
			box = "closed"
		emit_signal("box_changed", name, box)  # `name` is the node name, e.g., "tile1"
