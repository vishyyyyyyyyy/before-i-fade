extends Area2D

signal clicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		
		$"../Deskcloseup2".visible=true
		
		$"../CanvasLayer".visible = true
		$"../CanvasLayer2".visible = true
		$"../CanvasLayer3".visible = true
		$"../CanvasLayer4".visible = true
		emit_signal("clicked")
