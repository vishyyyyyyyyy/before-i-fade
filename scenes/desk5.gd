extends Area2D
signal diaryentry2
signal diaryentry3
signal diaryentry4
signal diaryentry5
signal diaryentry6

func _ready() -> void:
	pass
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
	
		if shape_idx == 0:
			$"../CanvasLayer3/CanvasModulate/Desk1".visible = true
			$CollisionPolygon2D.disabled = false
			print("Clicked shape 1")

		if shape_idx == 2:
			$CollisionShape2D.disabled = true
			print("Clicked shape 2")
			$"../CanvasLayer5/Label".visible = false
			$"../CanvasLayer3/CanvasModulate/Diaryentry5".visible = true
			Global.reusabledesk = 5
			emit_signal("diaryentry5")
