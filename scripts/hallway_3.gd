extends Node2D


func _ready() -> void:
	if get_tree().current_scene.scene_file_path == "res://scenes/hallway4.tscn":
		$CanvasLayer/Node2D/arrow.play("arrow")
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"



	if Global.character == "girlGhost":
		$CanvasLayer3/CanvasModulate/Girlframe5.visible=false
	if Global.character == "boyGhost":
		$CanvasLayer3/CanvasModulate/Girlframe5.visible=true
	
