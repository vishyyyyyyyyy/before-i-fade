extends Node2D

var segment_data := [
	{ "starts": [0.0], "ends": [4.0] }, 
	{ "starts": [0.0], "ends": [3.0] }, 
	{ "starts": [0.0], "ends": [2.0] }, 
	
]
@onready var anim_players := [
	$CanvasLayer4/diaryentry2,
	$CanvasLayer4/diaryentry3,
	$CanvasLayer4/diaryentry4,
]
var anim_index := 0
var anim: AnimationPlayer
var dialogue_active := false
var segment_index := 0
var animating := true
var segment_starts
var segment_ends
	
signal dialogue_finished(index)


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

	$CanvasLayer5/Label.visible=true
	$desk.diaryentry2.connect(diaryentry2)
	$desk.diaryentry3.connect(diaryentry3)
	$desk.diaryentry4.connect(diaryentry4)
	if Global.reusabledesk >=2:
		$ghostlayer/blobGhostPlayer.position.x = 200

func _process(_delta):
	if not dialogue_active or not animating:
		return
	
	if anim.current_animation == "":
		return # No animation playing, skip

	if anim.get_current_animation_position() >= segment_ends[segment_index]:
		anim.pause()
		animating = false

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
	
	if anim_index == 0:
		if Global.character =="girlGhost":
			anim_name = "girltext"

		elif Global.character =="boyGhost":
			anim_name ="boytext"
		else:
			print("error animating text")
	
	if anim_index == 1:
		$CanvasLayer4/diaryentry2/GirlGhost.visible=false
		$CanvasLayer4/diaryentry2/BoyGhost.visible=false
		$CanvasLayer4/diaryentry2/GirlGhost2.visible=false
		$CanvasLayer4/diaryentry2/BoyGhost2.visible=false
		$CanvasLayer4/diaryentry2/Label.visible=false
		$CanvasLayer4/diaryentry2/skip.visible=false

		if Global.character =="girlGhost":
			anim_name = "girltext"

		elif Global.character =="boyGhost":
			anim_name ="boytext"
		else:
			print("error animating text")
	
	if anim_index ==2:
		$CanvasLayer4/diaryentry2/GirlGhost.visible=false
		$CanvasLayer4/diaryentry2/BoyGhost.visible=false
		$CanvasLayer4/diaryentry2/GirlGhost2.visible=false
		$CanvasLayer4/diaryentry2/BoyGhost2.visible=false
		$CanvasLayer4/diaryentry2/Label.visible=false
		$CanvasLayer4/diaryentry2/skip.visible=false
		
		$CanvasLayer4/diaryentry3/GirlGhost.visible=false
		$CanvasLayer4/diaryentry3/BoyGhost.visible=false
		$CanvasLayer4/diaryentry3/Label.visible=false
		$CanvasLayer4/diaryentry3/skip.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	anim.play(anim_name) 
	   
	await dialogue_finished 



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
		$CanvasLayer4/diaryentry2/GirlGhost.visible=false
		$CanvasLayer4/diaryentry2/BoyGhost.visible=false
		$CanvasLayer4/diaryentry2/GirlGhost2.visible=false
		$CanvasLayer4/diaryentry2/BoyGhost2.visible=false
		$CanvasLayer4/diaryentry2/Label.visible=false
		$CanvasLayer4/diaryentry2/skip.visible=false
		$ghostlayer/Node2D/arrow.play("arrow")
		
			
	if anim_index ==1:
		$CanvasLayer4/diaryentry3/GirlGhost.visible=false
		$CanvasLayer4/diaryentry3/BoyGhost.visible=false
		$CanvasLayer4/diaryentry3/Label.visible=false
		$CanvasLayer4/diaryentry3/skip.visible=false
		
	if anim_index == 2: 
		$CanvasLayer4/diaryentry4/GirlGhost.visible=false
		$CanvasLayer4/diaryentry4/BoyGhost.visible=false
		$CanvasLayer4/diaryentry4/Label.visible=false
		$CanvasLayer4/diaryentry4/skip.visible=false
		
	emit_signal("dialogue_finished", anim_index)



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
			print("call end dialogue")
			end_dialogue()

func diaryentry2():
	
	await start_dialogue(0)
	$ghostlayer/blobGhostPlayer.position.x=1907
	$ghostlayer/blobGhostPlayer.position.y=602
	$CanvasLayer4/Area2D.visible=true
	$desk/CollisionPolygon2D.disabled=true
	$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
		
func diaryentry3():
	await start_dialogue(1)
	$ghostlayer/blobGhostPlayer.position.x=1907
	$ghostlayer/blobGhostPlayer.position.y=602
	$CanvasLayer4/Area2D.visible=true
	$desk/CollisionPolygon2D.disabled=true
	$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
	Global.reusablehallway = 1


func diaryentry4():
	await start_dialogue(2)
	$ghostlayer/blobGhostPlayer.position.x=1907
	$ghostlayer/blobGhostPlayer.position.y=602
	$CanvasLayer4/Area2D.visible=true
	$desk/CollisionPolygon2D.disabled=true
	$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
	$CanvasLayer5/Label4.visible=true
	$SceneTrigger/CollisionShape2D.disabled=true
	Global.reusablehallway = 4
	
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
