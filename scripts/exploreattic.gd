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


func _on_body_exited(body):
	if body.name == "blobGhostPlayer":
		player_inside = false

func _process(delta: float) -> void:
	if player_inside and Input.is_action_pressed("interact"):
		print("interact pressed on area")
		emit_signal("clicked", label_text)
		
var current_shape := -1

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "blobGhostPlayer":
		current_shape = local_shape_index

		if current_shape == 0:
			$Node2D/EAnim.play("E")

		if current_shape == 1:
			$Node2D/EAnim.play("E")
			
		if current_shape == 2:
			$Node2D/EAnim.play("E")
			
		if current_shape == 3:
			$Node2D/EAnim.play("E")
			
		if current_shape == 4:
			$Node2D/EAnim.play("E")
			
		if current_shape == 5:
			$Node2D/EAnim.play("E")
			
		if current_shape == 6:
			$Node2D2/EAnim.play("E")
			
		if current_shape == 7:
			$Node2D2/EAnim.play("E")
			
		if current_shape == 8:
			$Node2D2/EAnim.play("E")
			
		if current_shape == 9:
			$Node2D2/EAnim.play("E")
			
		if current_shape == 10:
			$Node2D2/EAnim.play("E")
			
		if current_shape == 11:
			$Node2D2/EAnim.play("E")
			
func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "blobGhostPlayer":

		if local_shape_index == 0:
			$Node2D/EAnim.stop()
			$Node2D/EAnim/letterE.visible = false
			
		if local_shape_index == 1:
			$Node2D/EAnim.stop()
			$Node2D/EAnim/letterE.visible = false
			
		if local_shape_index == 2:
			$Node2D/EAnim.stop()
			$Node2D/EAnim/letterE.visible = false
			
		if local_shape_index == 3:
			$Node2D/EAnim.stop()
			$Node2D/EAnim/letterE.visible = false
			
		if local_shape_index == 4:
			$Node2D/EAnim.stop()
			$Node2D/EAnim/letterE.visible = false
			
		if local_shape_index == 5:
			$Node2D/EAnim.stop()
			$Node2D/EAnim/letterE.visible = false
			
		elif local_shape_index == 6:
			$Node2D2/EAnim.stop()
			$Node2D2/EAnim/letterE.visible = false
			
		elif local_shape_index == 7:
			$Node2D2/EAnim.stop()
			$Node2D2/EAnim/letterE.visible = false
			
		elif local_shape_index == 8:
			$Node2D2/EAnim.stop()
			$Node2D2/EAnim/letterE.visible = false
			
		elif local_shape_index == 9:
			$Node2D2/EAnim.stop()
			$Node2D2/EAnim/letterE.visible = false
			
		elif local_shape_index == 10:
			$Node2D2/EAnim.stop()
			$Node2D2/EAnim/letterE.visible = false
			
		elif local_shape_index == 11:
			$Node2D2/EAnim.stop()
			$Node2D2/EAnim/letterE.visible = false

		if local_shape_index == current_shape:
			current_shape = -1
