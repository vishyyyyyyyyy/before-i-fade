extends Area2D
signal combpress

# Called when the node enters the scene tree for the first time.
var player_inside := false

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

func _input(event):
	if player_inside and event.is_action_pressed("interact"):
		print("interact pressed on area")
		emit_signal("combpress")
		print("combpressed")
	
