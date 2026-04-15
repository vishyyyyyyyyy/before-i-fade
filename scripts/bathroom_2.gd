extends Node2D
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer3/Node2D/arrow.play("arrow")
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"


func _on_texture_button_pressed() -> void:
	$TextureButton/AudioStreamPlayer2D.play()


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
