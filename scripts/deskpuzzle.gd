extends Area2D

signal clicked

var player_inside = false

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		open_desk()

#func _input_event(viewport, event, shape_idx):
	#if event is InputEventMouseButton \
	#and event.pressed \
	#and event.button_index == MOUSE_BUTTON_LEFT:
		#open_desk()

func open_desk():
	$"../Deskcloseup2".visible = true
	$"../CanvasLayer".visible = true
	$"../CanvasLayer2".visible = true
	$"../CanvasLayer3".visible = true
	$"../CanvasLayer4".visible = true
	emit_signal("clicked")
	$Node2D/EAnim.stop()
	$Node2D/EAnim/letterE.visible = false

func _on_body_entered(body):
	print("entered")
	if body.name == "blobGhostPlayer":
		player_inside = true
		$Node2D/EAnim.play("E")

func _on_body_exited(body):
	if body.name == "blobGhostPlayer":
		player_inside = false
		$Node2D/EAnim.stop()
		$Node2D/EAnim/letterE.visible = false
