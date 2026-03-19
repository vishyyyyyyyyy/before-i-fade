extends Node2D
var segment_data := [
	{ "starts": [0.0], "ends": [2.0] }, 
	{ "starts": [0.0, 4.0, 8.0, 12.0], "ends": [2.0, 6.0, 10.0, 14.0] },
	{ "starts": [0.0], "ends": [2.0] }, # fail
]
@onready var anim_players := [
	$CanvasLayer4/diaryentry5,
	$ghostlayer/ghosttext,
	$CanvasLayer5/bedroomfailghost#fail
]
var anim_index := 0
var anim: AnimationPlayer
var dialogue_active := false
var segment_index := 0
var animating := true
var segment_starts
var segment_ends
	
signal dialogue_finished(index)

var repeat_lines = [
	'"I feel like I\'ve been here before..."',
	'"This place feels familiar."',
	'"Didn\'t I just do this?"',
	'"Why am I back here again?"',
	'"I swear I was just here."',
	'"Something isn\'t right..."'
]

func fade_out_music():
	var tween = create_tween()
	tween.tween_property(MusicManager.music_player, "volume_db", -40, 5.0)

func fade_in_music():
	var tween = create_tween()
	tween.tween_property(MusicManager.music_player, "volume_db", 0, 8.0)


func _ready():
	#Global.bedroomdiary4fail = true
	if Global.bedroomdiary4fail == true:
		$CanvasLayer5/bedroomfailghost/Label.text  = repeat_lines.pick_random()
		fade_out_music()
		$ghostlayer/failpuzzlecutscene/AnimationPlayer.play("text")
		await get_tree().create_timer(16).timeout
		await start_dialogue(2)
	else:
		MusicManager.music_player.pitch_scale = 1.0
		MusicManager.play_scene_music("menu")

	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"
	$CanvasLayer5/Label.visible=true
	$ghostlayer/LineEdit.editable =false
	$desk.diaryentry5.connect(diaryentry5)
	$CanvasLayer4/Area2D.input_event.connect(_on_area_input)

func _on_area_input(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		pressed()

func _process(_delta):
	if not dialogue_active or not animating:
		return
	
	if anim.current_animation == "":
		return # No animation playing, skip

	if anim.get_current_animation_position() >= segment_ends[segment_index]:
		anim.pause()
		animating = false

func start_dialogue(index: int):
	
	print("Starting dialogue:", index)
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
		$CanvasLayer5/bedroomfailghost/Label.visible=false
		$CanvasLayer5/bedroomfailghost/GirlGhost.visible=false
		$CanvasLayer5/bedroomfailghost/BoyGhost.visible=false
		$CanvasLayer5/bedroomfailghost/skip.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	
	if anim_index == 1:
		$CanvasLayer5/bedroomfailghost/Label.visible=false
		$CanvasLayer5/bedroomfailghost/GirlGhost.visible=false
		$CanvasLayer5/bedroomfailghost/BoyGhost.visible=false
		$CanvasLayer5/bedroomfailghost/skip.visible=false
		
		$CanvasLayer4/diaryentry5/GirlGhost.visible=false
		$CanvasLayer4/diaryentry5/BoyGhost.visible=false
		$CanvasLayer4/diaryentry5/Label.visible=false
		$CanvasLayer4/diaryentry5/skip.visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
			
	if anim_index == 2:
		if Global.character =="girlGhost":
			anim_name = "repeatgirl"

		elif Global.character =="boyGhost":
			anim_name ="repeatboy"
		else:
			print("error animating text")
			
	anim.play(anim_name) 
	   
	await dialogue_finished 



func _input(event):
	if not dialogue_active:
		return

	if event.is_action_pressed("ui_accept") and not event.is_echo():
		textskip()	



func end_dialogue():
	dialogue_active = false
	anim.stop()

	print("Dialogue finished:", anim_index)
	if anim_index == 0:
		$CanvasLayer4/diaryentry5/GirlGhost.visible=false
		$CanvasLayer4/diaryentry5/BoyGhost.visible=false
		$CanvasLayer4/diaryentry5/Label.visible=false
		$CanvasLayer4/diaryentry5/skip.visible=false
		
			
	if anim_index ==1:
		$ghostlayer/ghosttext/Label4.visible=false
		$ghostlayer/ghosttext/GirlGhost.visible=false
		$ghostlayer/ghosttext/skip.visible=false
		$ghostlayer/ghosttext/BoyGhost.visible=false
		
	if anim_index == 2:
		$CanvasLayer5/bedroomfailghost/Label.visible=false
		$CanvasLayer5/bedroomfailghost/GirlGhost.visible=false
		$CanvasLayer5/bedroomfailghost/BoyGhost.visible=false
		$CanvasLayer5/bedroomfailghost/skip.visible=false
		pass

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


func diaryentry5():
	await start_dialogue(0)
	$ghostlayer/blobGhostPlayer.position.x=1907
	$ghostlayer/blobGhostPlayer.position.y=602
	$ghostlayer/blobGhostPlayer.position.x=1897
	$ghostlayer/blobGhostPlayer.position.y=555
	$CanvasLayer4/Area2D.visible=true
	$desk/CollisionPolygon2D.disabled=true
	$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
	#$SceneTrigger/CollisionShape2D.disabled=true
		
func pressed():
	$CanvasLayer3/CanvasModulate/ColorRect2.visible=false
	$CanvasLayer3/CanvasModulate/ColorRect2.visible=false
	await start_dialogue(1)
	$ghostlayer/Label.visible=true
	$ghostlayer/Area2D/CollisionShape2D.disabled=false
	
