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
		$"../../CanvasLayer3/CanvasModulate/Diaryblank".visible=false
		$"../../CanvasLayer3/CanvasModulate/Desk1".visible=false
		$"../../CanvasLayer3/CanvasModulate/Diaryentry2".visible=false
		$"../../CanvasLayer3/CanvasModulate/Diaryentry4".visible=false
		left.set_deferred("disabled", true)
		right.set_deferred("disabled", true)
		leftarrow.visible=false
		rightarrow.visible=false
		emit_signal("pressed")


var arrow = ""
@onready var left = $"../../CanvasLayer3/reread/left" 
@onready var right = $"../../CanvasLayer3/reread2/right"

@onready var leftarrow = $"../../CanvasLayer3/reread/Ghostarrow"
@onready var rightarrow =$"../../CanvasLayer3/reread2/Ghostarrow"

func _on_left_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		arrow = "left"
		switcharrow()
	
func _on_right_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		arrow = "right"
		switcharrow()

func switcharrow():
	left.set_deferred("disabled", true)
	right.set_deferred("disabled", true)
	leftarrow.visible=false
	rightarrow.visible=false

	if arrow == "right" and $"../../CanvasLayer3/CanvasModulate/Diaryentry4".visible :
		print("right press")
		$"../../CanvasLayer3/CanvasModulate/Diaryentry5".visible=true
		$"../../CanvasLayer3/CanvasModulate/Diaryentry4".visible=false
		right.set_deferred("disabled", true)
		left.set_deferred("disabled", false)
		leftarrow.visible=true
	
	elif arrow == "right" and $"../../CanvasLayer3/CanvasModulate/Diaryentry2".visible :
		print("right press")
		$"../../CanvasLayer3/CanvasModulate/Diaryentry4".visible=true
		$"../../CanvasLayer3/CanvasModulate/Diaryentry2".visible=false
		right.set_deferred("disabled", false)
		left.set_deferred("disabled", false)
		leftarrow.visible=true
		rightarrow.visible=true

	elif arrow == "left" and $"../../CanvasLayer3/CanvasModulate/Diaryentry5".visible:
		print("left press")
		$"../../CanvasLayer3/CanvasModulate/Diaryentry4".visible=true
		$"../../CanvasLayer3/CanvasModulate/Diaryentry5".visible=false
		right.set_deferred("disabled", false)
		left.set_deferred("disabled", false)
		rightarrow.visible=true
		leftarrow.visible=true
		
	elif arrow == "left" and $"../../CanvasLayer3/CanvasModulate/Diaryentry4".visible:
		print("left press")
		$"../../CanvasLayer3/CanvasModulate/Diaryentry2".visible=true
		$"../../CanvasLayer3/CanvasModulate/Diaryentry4".visible=false
		right.set_deferred("disabled", false)
		left.set_deferred("disabled", true)
		rightarrow.visible=true
