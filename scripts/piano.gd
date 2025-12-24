extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var solution = {"triangle", "cat", "circle", "x"}

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:

			if shape_idx == 0:
				$CollisionShape2D/ColorRect.visible=true
				print("triangle")
			if shape_idx == 1:
				$CollisionShape2D2/ColorRect.visible=true
				print("star")
			if shape_idx == 2:
				$CollisionShape2D3/ColorRect.visible=true
				print("circle")
			if shape_idx == 3:
				$CollisionShape2D4/ColorRect.visible=true
				print("arrow")
			if shape_idx == 4:
				$CollisionShape2D5/ColorRect.visible=true
				print("x")
			if shape_idx == 5:
				$CollisionShape2D6/ColorRect.visible=true
				print("diamond")
			if shape_idx == 6:
				$CollisionShape2D7/ColorRect.visible=true
				print("cat")
			if shape_idx == 7:
				$CollisionShape2D8/ColorRect.visible=true
				print("check")
			if shape_idx == 8:
				$CollisionShape2D9/ColorRect.visible=true
				print("h")
