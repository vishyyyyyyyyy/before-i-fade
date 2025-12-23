extends Area2D
signal pressed

@export var normal_texture: Texture2D
@export var hover_texture: Texture2D

@onready var sprite: Sprite2D = $Menubanner

var counter =0
func _on_mouse_entered():
	sprite.texture = hover_texture
	print("hover works")
	
func _on_mouse_exited():
	sprite.texture = normal_texture
	print("exited")
	

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		counter +=1
		if counter ==1:
			$".".visible=false
			$CollisionShape2D.disabled=true
			$"../../CanvasLayer3/CanvasModulate/Diaryentry2".visible=false
			$"../../CanvasLayer5/Label2".visible=true
			$"../../CanvasLayer3/CanvasModulate/Desk1".visible=false
			$"../../SceneTrigger/CollisionShape2D".disabled=false
			counter +=1
		if counter ==2:
			$".".visible=false
			$"../../CanvasLayer5/Label2".visible=false
			$CollisionShape2D.disabled=true
			$"../../CanvasLayer3/CanvasModulate/Diaryentry3".visible=false
			$"../../CanvasLayer5/Label3".visible=true
			$"../../CanvasLayer3/CanvasModulate/Desk1".visible=false
			$"../../SceneTrigger/CollisionShape2D".disabled=false
			$"../../CanvasLayer3/CanvasModulate/Diaryentry3".visible=false
		emit_signal("pressed")
