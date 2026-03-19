#extends Area2D
#signal diaryentry5
#
#var player_inside := false
#
#func _ready():
	#body_entered.connect(_on_body_entered)
	#body_exited.connect(_on_body_exited)
#
#func _on_body_entered(body):
	#if body.name == "blobGhostPlayer":
		#player_inside = true
#
#func _on_body_exited(body):
	#if body.name == "blobGhostPlayer":
		#player_inside = false
#
#
#func _input_event(viewport, event, shape_idx):
	#if player_inside and Input.is_action_pressed("interact"):
	#
		#if shape_idx == 0:
			#$"../CanvasLayer3/CanvasModulate/Desk1".visible = true
			#$CollisionPolygon2D.disabled = false
			#print("Clicked shape 1")
#
		#if shape_idx == 2:
			#$CollisionShape2D.disabled = true
			#print("Clicked shape 2")
			#$"../CanvasLayer5/Label".visible = false
			#$"../CanvasLayer3/CanvasModulate/Diaryentry5".visible = true
			#Global.reusabledesk = 5
			#emit_signal("diaryentry5")

extends Area2D
signal diaryentry5

var player_inside := false
var desk_opened := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

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
	# Only allow mouse clicks if player is inside the desk area
	if not player_inside:
		return
	
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:

		if shape_idx == 0:
			pass

		if shape_idx == 1:
			open_diary()

func open_desk():
	if desk_opened:
		return # already opened
	$"../CanvasLayer3/CanvasModulate/Desk1".visible = true
	$"../CanvasLayer3/CanvasModulate/ColorRect2".visible=true
	$CollisionPolygon2D.disabled = false
	print("Clicked shape 1")
	desk_opened = true

func open_diary():
	if not desk_opened:
		return # can't open diary until desk is open
	$CollisionShape2D.disabled = true
	print("Clicked shape 2")
	$"../CanvasLayer5/Label".visible = false
	Global.reusabledesk = 5
	$"../CanvasLayer3/CanvasModulate/Diaryblank".visible=true
	fade_in_diary($"../CanvasLayer3/CanvasModulate/Diaryentry5")
	emit_signal("diaryentry5")

func fade_in_diary(diary_node: Node2D, delay: float = 0.0) -> void:
	if delay > 0:
		await get_tree().create_timer(delay).timeout

	diary_node.visible = true
	diary_node.modulate.a = 0.0
	fading_in = true

	diary = diary_node
