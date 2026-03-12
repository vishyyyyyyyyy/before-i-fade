extends Node2D

@onready var pause_menu = $CanvasPause/PauseMenu
func toggle_pause():
	$CanvasPause/PauseMenu/resume/Label.text = "Game Paused"
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	$CanvasPause/ColorRect2.visible=true
	$CanvasPause/Menucard2.visible=true


func _ready():
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"
		
	if get_tree().current_scene.scene_file_path == "res://scenes/livingroom2.tscn":
		$ghostlayer/Node2D/arrow.play("arrow")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func _on_resume_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_tree().paused = false
			$CanvasPause/PauseMenu.visible = false
			$CanvasPause/PauseMenu/resume/Label.text = "Game Resumed"
			$CanvasPause/ColorRect2.visible=false
			$CanvasPause/Menucard2.visible=false
			print("pressed") 

func _on_music_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		MusicManager.toggle_music()

		if MusicManager.music_on:
			$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
		else:
			$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"


func _on_controls_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		$CanvasPause/settingsControl.visible=true
		$CanvasPause/PauseMenu.visible=false


func _on_main_menu_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
 

func _on_close_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().paused = !get_tree().paused
		pause_menu.visible = get_tree().paused
		$CanvasPause/PauseMenu.visible=false
		$CanvasPause/ColorRect2.visible=false
		$CanvasPause/Menucard2.visible=false


func _on_settingsclose_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	$CanvasPause/settingsControl.visible=false
	$CanvasPause/PauseMenu.visible=true
