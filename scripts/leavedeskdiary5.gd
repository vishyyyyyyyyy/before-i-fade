extends Area2D
signal pressed

@export var normal_texture: Texture2D
@export var hover_texture: Texture2D

@onready var sprite: Sprite2D = $Menubanner

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
		$".".visible=false
		$CollisionShape2D.disabled=true
		$"../../CanvasLayer3/CanvasModulate/Diaryentry5".visible=false
		$"../../CanvasLayer5/Label2".visible=true
		$"../../CanvasLayer3/CanvasModulate/Desk1".visible=false
		$"../../SceneTrigger/CollisionShape2D".disabled=false
		emit_signal("pressed")
