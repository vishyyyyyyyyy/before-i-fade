extends Node2D

func _ready() -> void:
	$CanvasLayer3/Node2D/arrow.play("arrow")
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"

func _on_texture_button_pressed() -> void:
	$TextureButton/AudioStreamPlayer2D.play()
