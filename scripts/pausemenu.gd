extends CanvasLayer


@onready var pause_menu = $PauseMenu

func _ready() -> void:
	if MusicManager.music_on:
		$PauseMenu/music/Label.text = "Music: ON"
	else:
		$PauseMenu/music/Label.text = "Music: OFF"


func toggle_pause():
	$PauseMenu/resume/Label.text = "Game Paused"
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	$ColorRect2.visible=true
	$Menucard2.visible=true


func _input(event):
	if event.is_action_pressed("ui_cancel") and !get_tree().paused:
		toggle_pause()
		
func _on_resume_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_tree().paused = false
			$PauseMenu.visible = false
			$PauseMenu/resume/Label.text = "Game Resumed"
			$ColorRect2.visible=false
			$Menucard2.visible=false
			print("pressed") 


func _on_music_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		MusicManager.toggle_music()

		if MusicManager.music_on:
			$PauseMenu/music/Label.text = "Music: ON"
		else:
			$PauseMenu/music/Label.text = "Music: OFF"


func _on_controls_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		$settingsControl.visible=true
		$PauseMenu.visible=false


func _on_main_menu_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().paused = false
		Global.hardmodefail=false
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
 

func _on_close_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().paused = !get_tree().paused
		pause_menu.visible = get_tree().paused
		$PauseMenu.visible=false
		$ColorRect2.visible=false
		$Menucard2.visible=false


func _on_settingsclose_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$settingsControl.visible=false
		$PauseMenu.visible=true
