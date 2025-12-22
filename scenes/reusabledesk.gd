extends Area2D
signal diaryentry2

func _ready() -> void:
	Global.reusabledesk =1
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
	
		if Global.reusabledesk == 1:
			if shape_idx == 0:
				$"../CanvasLayer3/CanvasModulate/Desk1".visible = true
				$CollisionPolygon2D.disabled=false
				print("Clicked shape 1")

			elif shape_idx == 1:
				$CollisionShape2D.disabled=true
				print("Clicked shape 2")
				$CollisionPolygon2D.disabled=true
				$"../CanvasLayer3/CanvasModulate/Diaryentry2".visible=true
				emit_signal("diaryentry2")
		
				
