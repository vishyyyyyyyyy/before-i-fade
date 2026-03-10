extends Area2D
signal clicked(text)

@export var label_text: String = ""

var player_inside := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

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
