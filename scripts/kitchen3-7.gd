extends Node2D


func _ready():
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"
	
	if get_tree().current_scene.scene_file_path == "res://scenes/kitchen4.tscn":
		$ghostlayer/Node2D/arrow.play("arrow")
		
