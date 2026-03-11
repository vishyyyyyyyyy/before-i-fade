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

func _on_body_exited(body):
	if body.name == "blobGhostPlayer":
		player_inside = false

func _process(delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		open_desk()

func _input_event(viewport, event, shape_idx):
	# Only allow mouse clicks if player is inside the desk area
	if not player_inside:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:

		if shape_idx == 0:
			open_desk()

		if shape_idx == 2:
			open_diary()

func open_desk():
	if desk_opened:
		return # already opened
	$"../CanvasLayer3/CanvasModulate/Desk1".visible = true
	$CollisionPolygon2D.disabled = false
	print("Clicked shape 1")
	desk_opened = true

func open_diary():
	if not desk_opened:
		return # can't open diary until desk is open
	$CollisionShape2D.disabled = true
	print("Clicked shape 2")
	$"../CanvasLayer5/Label".visible = false
	$"../CanvasLayer3/CanvasModulate/Diaryentry5".visible = true
	Global.reusabledesk = 5
	emit_signal("diaryentry5")
