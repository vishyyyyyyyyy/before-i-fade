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
			$"../../CanvasLayer5/Label4".visible=false
			$"../../CanvasLayer5/Label3".visible=false
			$"../../CanvasLayer3/CanvasModulate/Desk1".visible=false
			$"../../CanvasLayer3/CanvasModulate/Diaryentry1".visible=false
			$"../../SceneTrigger/CollisionShape2D".disabled=false
			counter +=1
		if counter ==2:
			$".".visible=false
			$"../../CanvasLayer5/Label2".visible=false
			$CollisionShape2D.disabled=true
			$"../../CanvasLayer3/CanvasModulate/Diaryentry3".visible=false
			$"../../CanvasLayer5/Label3".visible=true
			$"../../CanvasLayer5/Label4".visible=false
			$"../../CanvasLayer5/Label2".visible=false
			$"../../CanvasLayer3/CanvasModulate/Desk1".visible=false
			$"../../SceneTrigger/CollisionShape2D".disabled=false
			$"../../CanvasLayer3/CanvasModulate/Diaryentry3".visible=false
			$"../../CanvasLayer3/CanvasModulate/Diaryblank".visible=false
			counter +=1
		if counter ==3:
			$".".visible=false
			$"../../CanvasLayer5/Label2".visible=false
			$CollisionShape2D.disabled=true
			$"../../CanvasLayer3/CanvasModulate/Diaryentry3".visible=false
			$"../../CanvasLayer5/Label4".visible=true
			$"../../CanvasLayer5/Label3".visible=false
			$"../../CanvasLayer5/Label2".visible=false
			$"../../CanvasLayer3/CanvasModulate/Desk1".visible=false
			$"../../SceneTrigger/CollisionShape2D".disabled=false
			$"../../CanvasLayer3/CanvasModulate/Diaryentry4".visible=false
			$"../../CanvasLayer3/CanvasModulate/Diaryentry3".visible=false
			$"../../CanvasLayer3/reread/Ghostarrow".visible=true
			counter +=1
		emit_signal("pressed")
		left.set_deferred("disabled", true)
		right.set_deferred("disabled", true)
		leftarrow.visible=false
		rightarrow.visible=false
		
		

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

	if Global.reusabledesk == 2:
		if arrow == "right":
			print("right press")
			$"../../CanvasLayer3/CanvasModulate/Diaryentry2".visible=false
			$"../../CanvasLayer3/CanvasModulate/Diaryentry3".visible=true
			right.set_deferred("disabled", true)
			left.set_deferred("disabled", false)
			leftarrow.visible=true

		if arrow == "left":
			print("left press")
			$"../../CanvasLayer3/CanvasModulate/Diaryentry2".visible=true
			$"../../CanvasLayer3/CanvasModulate/Diaryentry3".visible=false
			right.set_deferred("disabled", false)
			left.set_deferred("disabled", true)
			rightarrow.visible=true

	else:
		$"../../CanvasLayer3/CanvasModulate/Diaryentry3".visible = false
		if arrow == "right":
			print("right press")
			$"../../CanvasLayer3/CanvasModulate/Diaryentry2".visible=false
			$"../../CanvasLayer3/CanvasModulate/Diaryentry4".visible=true
			right.set_deferred("disabled", true)
			left.set_deferred("disabled", false)
			leftarrow.visible=true

		if arrow == "left":
			print("left press")
			$"../../CanvasLayer3/CanvasModulate/Diaryentry2".visible=true
			$"../../CanvasLayer3/CanvasModulate/Diaryentry4".visible=false
			right.set_deferred("disabled", false)
			left.set_deferred("disabled", true)
			rightarrow.visible=true
