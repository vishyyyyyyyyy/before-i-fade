extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_texture_button_pressed() -> void:
	$ColorRect2/TextureButton/AudioStreamPlayer2D.play()


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
