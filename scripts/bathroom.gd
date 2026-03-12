extends Node2D
var segment_starts := [0.0, 3.0]
var segment_ends   := [2.0, 6.0]
var dialogue_active := false
var segment_index := 0
var animating := true
var player_in_area = false
@onready var anim := $CanvasLayer3/AnimationPlayer
@onready var pause_menu = $CanvasPause/PauseMenu


func _ready():
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"
	$CanvasLayer3/AnimationPlayer.play("text")
	dialogue_active = true  
	await $CanvasLayer3/AnimationPlayer.animation_finished

func toggle_pause():
	$CanvasPause/PauseMenu/resume/Label.text = "Game Paused"
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	$CanvasPause/ColorRect2.visible=true
	$CanvasPause/Menucard2.visible=true
	
	
func _on_texture_button_pressed() -> void:
	$ColorRect2/TextureButton/AudioStreamPlayer2D.play()


func _process(_delta):
	if animating and anim.current_animation_position >= segment_ends[segment_index]:
		anim.pause()
		animating = false
	if player_in_area and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/mirror.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
		
	if not dialogue_active:
		return

	if event.is_action_pressed("ui_accept"):
		textskip()

func end_dialogue():
	dialogue_active = false
	anim.stop()
	print("Dialogue finished")
	$CanvasLayer3/Label3.visible=true

func textskip():
	if animating:
		anim.seek(segment_ends[segment_index], true)
		anim.pause()
		animating = false
	else:
		segment_index += 1
		if segment_index < segment_starts.size():
			anim.seek(segment_starts[segment_index], true)
			anim.play()
			animating = true
		else:
			end_dialogue()
			
 

func _on_area_2d_body_entered(body: Node2D) -> void:
	player_in_area = true
	$CanvasLayer2/Node2D/EAnim.play("E")

func _on_area_2d_body_exited(body: Node2D) -> void:
	player_in_area = false
	$CanvasLayer2/Node2D/EAnim.stop()
	$CanvasLayer2/Node2D/EAnim/letterE.visible = false

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
