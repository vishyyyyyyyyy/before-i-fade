extends Node2D

var character_selected := false
var segment_data := [
	{ "starts": [0.0], "ends": [2.0] },
	{ "starts": [0.0, 2.0, 5.0], "ends": [1.0, 4.0, 7.0] }
]
@onready var anim_players := [
	$AnimationPlayer,
	$AnimationPlayer2,
]
var anim_index := 0
var anim: AnimationPlayer
var dialogue_active := false
var segment_index := 0
var animating := true
var segment_starts
var segment_ends


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
	print("SCENE:", get_tree().current_scene.name)
	$ColorRect/boy.disabled=true
	$ColorRect/girl.disabled=true
	$Node/Area2D/CollisionPolygon2D.disabled=true
	$Sponge.visible=false
	start_dialogue(0)
	dialogue_active = true
	await $AnimationPlayer.animation_finished
	
func _process(_delta):
	if not dialogue_active or not animating:
		return

	if anim.get_current_animation_position() >= segment_ends[segment_index]:
		anim.pause()
		animating = false

func scrubmirror():
	$Label2.visible=true
	$Sponge.visible=true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Node/Area2D/CollisionPolygon2D.disabled=false
	$Area2D2/CollisionShape2D3.disabled=false
	#await signals from area2d girl boy banners below
	$Area2D.connect("char_chosen", Callable(self, "_on_char_chosen"))
	$Area2D2.connect("char_chosen", Callable(self, "_on_char_chosen"))

func changescene():
	get_tree().change_scene_to_file("res://scenes/bathroom2.tscn")

func _on_char_chosen():
	if character_selected:
		return 
	character_selected = true
	$Label3.visible=false
	$Area2D.visible=false
	$Area2D2.visible=false
	print("Player chose a character!")
	print(Global.character)
	start_dialogue(1)
	dialogue_active = true


func start_dialogue(index: int):
	# Safety
	if index >= anim_players.size():
		return

	# Stop all animations
	for a in anim_players:
		a.stop()

	anim_index = index
	anim = anim_players[anim_index]

	segment_starts = segment_data[anim_index].starts
	segment_ends   = segment_data[anim_index].ends

	segment_index = 0
	animating = true
	dialogue_active = true
	
	var anim_name := ""
	
	if anim_index ==0:
		anim_name ="text"
	
	if anim_index == 1:
		if Global.character =="girlGhost":
			anim_name = "girlghost"

		elif Global.character =="boyGhost":
			anim_name ="boyghost"
		else:
			print("error animating text")
	
	anim.play(anim_name)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
		
	if not dialogue_active:
		return

	if event.is_action_pressed("ui_accept") and not event.is_echo():
		textskip()

func end_dialogue():
	dialogue_active = false
	anim.stop()

	print("Dialogue finished:", anim_index)
	if anim_index == 0:
		scrubmirror()
	if anim_index ==1:
		changescene()
		
		
	anim_index += 1

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
