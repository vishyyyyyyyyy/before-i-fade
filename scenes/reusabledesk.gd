extends Area2D
signal diaryentry2
signal diaryentry3
signal diaryentry4

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

		elif Global.reusabledesk == 1 and shape_idx == 1:
			$"../CanvasLayer5/Label".visible = false
			print("Clicked shape 2")
			$CollisionShape2D.disabled = true
			$CollisionPolygon2D.disabled = true
			$"../CanvasLayer3/CanvasModulate/Diaryentry2".visible = true
			emit_signal("diaryentry2")

		elif Global.reusabledesk == 2 and shape_idx == 2:
			$CollisionShape2D.disabled = true
			$"../CanvasLayer4/Area2D/CollisionShape2D".disabled=true
			print("Clicked shape 2")
			$"../CanvasLayer5/Label".visible = false
			$"../CanvasLayer3/CanvasModulate/Diaryentry3".visible = true
			emit_signal("diaryentry3")
		
		elif Global.reusabledesk == 3 and shape_idx == 2:
			$CollisionShape2D.disabled = true
			print("Clicked shape 2")
			$"../CanvasLayer5/Label".visible = false
			$"../CanvasLayer3/CanvasModulate/Diaryentry4".visible = true
			Global.reusabledesk = 4
			emit_signal("diaryentry4")
			
		elif Global.reusabledesk == 4 and shape_idx == 2:
			$CollisionShape2D.disabled = true
			print("Clicked shape 2")
			$"../CanvasLayer5/Label".visible = false
			$"../CanvasLayer3/CanvasModulate/Diaryentry5".visible = true
			Global.reusabledesk = 5
			emit_signal("diaryentry5")
			
		elif Global.reusabledesk == 5 and shape_idx == 2:
			$CollisionShape2D.disabled = true
			print("Clicked shape 2")
			$"../CanvasLayer5/Label".visible = false
			$"../CanvasLayer3/CanvasModulate/Diaryentry4".visible = true
			Global.reusabledesk = 6
			emit_signal("diaryentry6")


		
		
				
