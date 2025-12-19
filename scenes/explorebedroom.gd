extends Area2D

@export var narration_text: String = ""

signal clicked(text: String)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clicked", narration_text)
