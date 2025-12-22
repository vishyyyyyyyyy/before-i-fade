extends Area2D
signal combpress

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		pass
		emit_signal("combpress")
		print("combpressed")
