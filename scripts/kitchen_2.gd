extends Node2D

@onready var pause_menu = $CanvasPause/PauseMenu
func toggle_pause():
	$CanvasPause/PauseMenu/resume/Label.text = "Game Paused"
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	$CanvasPause/ColorRect2.visible=true
	$CanvasPause/Menucard2.visible=true


func _ready() -> void:
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"

	
	if Global.reusablehallway ==4:
		$ghostlayer/Label.visible=true
		$ghostlayer/scenetrigger/CollisionShape2D.disabled=true
		$ghostlayer/scenetrigger/CollisionShape2D2.disabled=false
		$ghostlayer/blobGhostPlayer.position.x=2137
		$ghostlayer/Node2D/arrow.play("arrow")
		Global.kitchen = 4
		print(Global.kitchen)
		
	if Global.livingroom == 1:
		Global.kitchen = 5
		$ghostlayer/scenetrigger/CollisionShape2D2.disabled=true
		$ghostlayer/scenetrigger/CollisionShape2D.disabled=false
		$ghostlayer/blobGhostPlayer.position.x=177
		$ghostlayer/Label13.visible=true
		print("bathroom count: " + str(Global.bathroomCount))
		print("reusabledesk count: " + str(Global.reusabledesk))
		print("reusablehallway count: " + str(Global.reusablehallway))
		print("kitchen: " + str(Global.kitchen))
		print("livingroom: " + str(Global.livingroom))



func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
		
		#var bathroomCount = 0
#var pastChar = ""
#var reusabledesk = 0
#var reusablehallway = 0
#var kitchen = 0
#var livingroom = 0

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
