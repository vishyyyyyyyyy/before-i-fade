extends Area2D
signal diaryentry2
signal diaryentry3
signal diaryentry4

var player_inside := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	#Global.reusabledesk = 2

func _on_body_entered(body):
	if body.name == "blobGhostPlayer":
		player_inside = true
		$Node2D/EAnim.play("E")

func _on_body_exited(body):
	if body.name == "blobGhostPlayer":
		player_inside = false
		$Node2D/EAnim.stop()
		$Node2D/EAnim/letterE.visible = false

func _process(delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		open_desk()

func _input_event(viewport, event, shape_idx):
	if not player_inside:
		return

	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:

		if Global.reusabledesk == 1 and shape_idx == 1:
			$"../CanvasLayer5/Label".visible = false
			print("Clicked shape 2")
			$CollisionShape2D.disabled = true
			$CollisionPolygon2D.disabled = true
			$"../CanvasLayer3/CanvasModulate/Diaryentry2".visible = true
			emit_signal("diaryentry2")

		elif Global.reusabledesk == 2 and shape_idx == 1:
			$CollisionShape2D.disabled = true
			$"../CanvasLayer4/Area2D/CollisionShape2D".disabled = true
			print("Clicked shape 2")
			$"../CanvasLayer5/Label".visible = false
			$"../CanvasLayer3/CanvasModulate/Diaryentry3".visible = true
			emit_signal("diaryentry3")
		
		elif Global.reusabledesk == 3 and shape_idx == 1:
			$CollisionShape2D.disabled = true
			print("Clicked shape 2")
			$"../CanvasLayer5/Label".visible = false
			$"../CanvasLayer3/CanvasModulate/Diaryentry4".visible = true
			Global.reusabledesk = 4
			emit_signal("diaryentry4")

func open_desk():
	$"../CanvasLayer3/CanvasModulate/Desk1".visible = true
	$CollisionPolygon2D.disabled = false
	print("Clicked shape 1")
