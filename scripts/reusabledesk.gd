extends Area2D
signal diaryentry2
signal diaryentry3
signal diaryentry4

var player_inside := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	#Global.reusabledesk = 3

func _on_body_entered(body):
	if body.name == "blobGhostPlayer":
		player_inside = true
		$Node2D/EAnim.play("E")

func _on_body_exited(body):
	if body.name == "blobGhostPlayer":
		player_inside = false
		$Node2D/EAnim.stop()
		$Node2D/EAnim/letterE.visible = false

var fading_in = false
var diary
func _process(delta):
	if fading_in and diary != null and diary.visible:
		diary.modulate.a = lerp(diary.modulate.a, 1.0, delta * 2.5)
		if diary.modulate.a > 0.99:
			diary.modulate.a = 1.0
			fading_in = false

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
			$"../CanvasLayer3/CanvasModulate/Diaryentry1".visible=true
			fade_in_diary($"../CanvasLayer3/CanvasModulate/Diaryentry2")
			emit_signal("diaryentry2")

		elif Global.reusabledesk == 2 and shape_idx == 1:
			$CollisionShape2D.disabled = true
			$"../CanvasLayer4/Area2D/CollisionShape2D".disabled = true
			print("Clicked shape 2")
			$"../CanvasLayer5/Label".visible = false
			$"../CanvasLayer3/CanvasModulate/Diaryblank".visible=true
			fade_in_diary($"../CanvasLayer3/CanvasModulate/Diaryentry3")
			emit_signal("diaryentry3")
		
		elif Global.reusabledesk == 3 and shape_idx == 1:
			$CollisionShape2D.disabled = true
			print("Clicked shape 2")
			$"../CanvasLayer5/Label".visible = false
			$"../CanvasLayer3/CanvasModulate/Diaryentry3".visible=true
			fade_in_diary($"../CanvasLayer3/CanvasModulate/Diaryentry4")
			Global.reusabledesk = 4
			emit_signal("diaryentry4")

func open_desk():
	$"../CanvasLayer3/CanvasModulate/Desk1".visible = true
	$CollisionPolygon2D.disabled = false
	print("Clicked shape 1")

func fade_in_diary(diary_node: Node2D, delay: float = 0.0) -> void:
	$"../AudioStreamPlayer".play()
	if delay > 0:
		await get_tree().create_timer(delay).timeout

	diary_node.visible = true
	diary_node.modulate.a = 0.0
	fading_in = true

	diary = diary_node
