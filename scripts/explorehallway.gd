extends Area2D
signal clicked(text)

@export var label_text: String = ""

var player_inside := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	body_shape_entered.connect(_on_body_shape_entered)
	body_shape_exited.connect(_on_body_shape_exited)

func _on_body_entered(body):
	if body.name == "blobGhostPlayer":
		player_inside = true
		#$Node2D/EAnim.play("E")

func _on_body_exited(body):
	if body.name == "blobGhostPlayer":
		player_inside = false
		#$Node2D/EAnim.stop()
		#$Node2D/EAnim/letterE.visible = false
		#$Node2D2/EAnim.stop()
		#$Node2D2/EAnim/letterE.visible = false

func _input(event):
	if player_inside and event.is_action_pressed("interact"):
		print("interact pressed on area")
		emit_signal("clicked", label_text)

var current_shape := -1

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "blobGhostPlayer":
		current_shape = local_shape_index

		if current_shape == 0:
			$Node2D/EAnim.play("E")

		elif current_shape == 1:
			$Node2D2/EAnim.play("E")
			
func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "blobGhostPlayer":

		if local_shape_index == 0:
			$Node2D/EAnim.stop()
			$Node2D/EAnim/letterE.visible = false

		elif local_shape_index == 1:
			$Node2D2/EAnim.stop()
			$Node2D2/EAnim/letterE.visible = false

		if local_shape_index == current_shape:
			current_shape = -1
