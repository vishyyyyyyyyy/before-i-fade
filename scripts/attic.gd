extends Node2D

@onready var narration_label: Label = $ghostlayer/explorelabel
@onready var explore_node: Node = $explore
var clicked_objects := {} 
var time_left_seconds

@onready var reset_timer = $Timer

var segment_data := [
	{ "starts": [0.0, 4.0], "ends": [2.0, 6.0] }, 
	{ "starts": [0.0, 4.0, 8.0], "ends": [2.0, 6.0, 10.0] }, 
	{ "starts": [0.0, 4.0, 8.0, 12.0, 16.0, 20.0], "ends": [2.0, 6.0, 10.0, 14.0, 18.0, 22.0] }, 
	{ "starts": [0.0, 4.0, 8.0, 12.0], "ends": [2.0, 6.0, 10.0, 14.0] }, 
	{ "starts": [0.0, 4.0, 8.0, 12.0, 18.0], "ends": [2.0, 6.0, 10.0, 16.0, 18.0, 20.0] }, 
	{ "starts": [0.0, 4.0, 8.0, 12.0], "ends": [2.0, 6.0, 10.0, 14.0] }, 
	{ "starts": [0.0, 4.0, 8.0, 12.0], "ends": [2.0, 6.0, 10.0, 14.0] }, 
	{ "starts": [0.0], "ends": [2.0] }, #pastchar1
	{ "starts": [0.0, 4.0, 8.0, 12.0, 16.0, 20.0], "ends": [2.0, 6.0, 10.0, 14.0, 18.0, 22.0] }, #pastchar2
	{ "starts": [0.0], "ends": [2.0] }, #fail puzzle
	
]
@onready var anim_players := [
	$ghostlayer/ghosttext,
	$ghostlayer/ghosttext2,
	$ghostlayer/ghosttext3,
	$ghostlayer/ghosttext4,
	$ghostlayer/ghosttext5,
	$ghostlayer/ghosttext6,
	$ghostlayer/ghosttext7,
	$ghostlayer/pastchar1,
	$ghostlayer/pastchar2,
	$ghostlayer/bedroomfailghost
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
	MusicManager.music_player.pitch_scale = 0.75
	reset_timer.timeout.connect(_on_reset_timeout)
	#Global.attic1fail = true
	if Global.attic1fail == true:
		$ghostlayer/bedroomfailghost/Label.text  = repeat_lines.pick_random()
		fade_out_music()
		$ghostlayer/failpuzzlecutscene/AnimationPlayer.play("text")
		await get_tree().create_timer(16).timeout
		await start_dialogue(9)
	else:
		MusicManager.music_player.pitch_scale = 0.75
		MusicManager.play_scene_music("menu")

	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"

	presentbox()
	$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	$ghostlayer/Bloodblanket.visible=true
	$ghostlayer/continue.pressed.connect(on_button_pressed)
	$CanvasLayer/CanvasModulate/box2.challengecompleted.connect(challengecompleted)
	$ghostlayer/choice.choice1.connect(choice1)
	$ghostlayer/choice2.choice2.connect(choice2)
	$ghostlayer/diarycontinue.diarypagecontinue.connect(diarypagecontinue)
	#unlockexplore()
	text()
	
	
func _process(delta: float) -> void:
	time_left_seconds = $ghostlayer/Timer2.time_left
	$ghostlayer/Label8.text = "%.1f" % time_left_seconds
	
	$ghostlayer/Label8.add_theme_color_override("font_color", Color(0,0,0))
	
	#  music speed control
	if not $ghostlayer/Timer2.is_stopped():
		var total_time = $ghostlayer/Timer2.wait_time
		var t = time_left_seconds / total_time
			# start slow (0.75) → end normal (1.0)
		MusicManager.music_player.pitch_scale = lerp(0.75, 0.4, t)
		
	if time_left_seconds < 11.0:
		if int(Time.get_ticks_msec() / 300) % 3 == 0:
			$ghostlayer/Label8.add_theme_color_override("font_color", Color(1,0,0))
		else:
			$ghostlayer/Label8.add_theme_color_override("font_color", Color(0,0,0))
	
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
		$ghostlayer/bedroomfailghost/Label.visible=false
		$ghostlayer/bedroomfailghost/GirlGhost.visible=false
		$ghostlayer/bedroomfailghost/BoyGhost.visible=false
		$ghostlayer/bedroomfailghost/skip.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	
	if anim_index == 1:
		$ghostlayer/bedroomfailghost/Label.visible=false
		$ghostlayer/bedroomfailghost/GirlGhost.visible=false
		$ghostlayer/bedroomfailghost/BoyGhost.visible=false
		$ghostlayer/bedroomfailghost/skip.visible=false
		
		$ghostlayer/pastchar1/Boy.visible=false
		$ghostlayer/pastchar1/Girl.visible=false
		$"ghostlayer/pastchar1/YN label".visible=false
		$ghostlayer/pastchar1/Label.visible=false
		$ghostlayer/pastchar1/skip.visible=false
		
		$ghostlayer/ghosttext/Label2.visible=false
		$ghostlayer/ghosttext/GirlGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost2.visible=false
		$ghostlayer/ghosttext/GirlGhost2.visible=false
		$ghostlayer/ghosttext/skip.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
			
	if anim_index == 2:
		$ghostlayer/bedroomfailghost/Label.visible=false
		$ghostlayer/bedroomfailghost/GirlGhost.visible=false
		$ghostlayer/bedroomfailghost/BoyGhost.visible=false
		$ghostlayer/bedroomfailghost/skip.visible=false
		
		$ghostlayer/pastchar1/Boy.visible=false
		$ghostlayer/pastchar1/Girl.visible=false
		$"ghostlayer/pastchar1/YN label".visible=false
		$ghostlayer/pastchar1/Label.visible=false
		$ghostlayer/pastchar1/skip.visible=false
		 
		$ghostlayer/ghosttext/Label2.visible=false
		$ghostlayer/ghosttext/GirlGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost2.visible=false
		$ghostlayer/ghosttext/GirlGhost2.visible=false
		$ghostlayer/ghosttext/skip.visible=false
		
		$ghostlayer/ghosttext2/Label3.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost2.visible=false
		$ghostlayer/ghosttext2/GirlGhost2.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
			
	if anim_index == 3:
		$ghostlayer/bedroomfailghost/Label.visible=false
		$ghostlayer/bedroomfailghost/GirlGhost.visible=false
		$ghostlayer/bedroomfailghost/BoyGhost.visible=false
		$ghostlayer/bedroomfailghost/skip.visible=false
		
		$ghostlayer/pastchar1/Boy.visible=false
		$ghostlayer/pastchar1/Girl.visible=false
		$"ghostlayer/pastchar1/YN label".visible=false
		$ghostlayer/pastchar1/Label.visible=false
		$ghostlayer/pastchar1/skip.visible=false
		
		$ghostlayer/ghosttext/Label2.visible=false
		$ghostlayer/ghosttext/GirlGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost2.visible=false
		$ghostlayer/ghosttext/GirlGhost2.visible=false
		$ghostlayer/ghosttext/skip.visible=false
		
		$ghostlayer/ghosttext2/Label3.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost2.visible=false
		$ghostlayer/ghosttext2/GirlGhost2.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		
		$ghostlayer/ghosttext3/Label6.visible=false
		$ghostlayer/ghosttext3/BoyGhost.visible=false
		$ghostlayer/ghosttext3/GirlGhost.visible=false
		$ghostlayer/ghosttext3/skip.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	
	if anim_index == 4:
		$ghostlayer/bedroomfailghost/Label.visible=false
		$ghostlayer/bedroomfailghost/GirlGhost.visible=false
		$ghostlayer/bedroomfailghost/BoyGhost.visible=false
		$ghostlayer/bedroomfailghost/skip.visible=false
		
		$"ghostlayer/pastchar2/Ex label".visible=false
		$ghostlayer/pastchar2/Label3.visible=false
		$ghostlayer/pastchar2/skip.visible=false
		$"ghostlayer/pastchar2/YN label".visible=false
		$ghostlayer/pastchar2/Boy1.visible=false
		$ghostlayer/pastchar2/Boy2.visible=false
		$ghostlayer/pastchar2/Boy3.visible=false
		$ghostlayer/pastchar2/Girl.visible=false
		$ghostlayer/pastchar2/Girl2.visible=false
		$ghostlayer/pastchar2/Girl3.visible=false
		$ghostlayer/pastchar2/Boy4.visible=false
		$ghostlayer/pastchar2/Boy5.visible=false
		$ghostlayer/pastchar2/Boy6.visible=false
		$ghostlayer/pastchar2/Girl4.visible=false
		$ghostlayer/pastchar2/Girl5.visible=false
		$ghostlayer/pastchar2/Girl6.visible=false
		
		$ghostlayer/pastchar1/Boy.visible=false
		$ghostlayer/pastchar1/Girl.visible=false
		$"ghostlayer/pastchar1/YN label".visible=false
		$ghostlayer/pastchar1/Label.visible=false
		$ghostlayer/pastchar1/skip.visible=false
		
		$ghostlayer/ghosttext/Label2.visible=false
		$ghostlayer/ghosttext/GirlGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost2.visible=false
		$ghostlayer/ghosttext/GirlGhost2.visible=false
		$ghostlayer/ghosttext/skip.visible=false
		
		$ghostlayer/ghosttext2/Label3.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost2.visible=false
		$ghostlayer/ghosttext2/GirlGhost2.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		
		$ghostlayer/ghosttext3/Label6.visible=false
		$ghostlayer/ghosttext3/BoyGhost.visible=false
		$ghostlayer/ghosttext3/GirlGhost.visible=false
		$ghostlayer/ghosttext3/skip.visible=false
		
		$ghostlayer/ghosttext4/Label4.visible=false
		$ghostlayer/ghosttext4/GirlGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost2.visible=false
		$ghostlayer/ghosttext4/GirlGhost2.visible=false
		$ghostlayer/ghosttext4/skip.visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	
	if anim_index == 5:
		$ghostlayer/bedroomfailghost/Label.visible=false
		$ghostlayer/bedroomfailghost/GirlGhost.visible=false
		$ghostlayer/bedroomfailghost/BoyGhost.visible=false
		$ghostlayer/bedroomfailghost/skip.visible=false
		
		$"ghostlayer/pastchar2/Ex label".visible=false
		$ghostlayer/pastchar2/Label3.visible=false
		$ghostlayer/pastchar2/skip.visible=false
		$"ghostlayer/pastchar2/YN label".visible=false
		$ghostlayer/pastchar2/Boy1.visible=false
		$ghostlayer/pastchar2/Boy2.visible=false
		$ghostlayer/pastchar2/Boy3.visible=false
		$ghostlayer/pastchar2/Girl.visible=false
		$ghostlayer/pastchar2/Girl2.visible=false
		$ghostlayer/pastchar2/Girl3.visible=false
		$ghostlayer/pastchar2/Boy4.visible=false
		$ghostlayer/pastchar2/Boy5.visible=false
		$ghostlayer/pastchar2/Boy6.visible=false
		$ghostlayer/pastchar2/Girl4.visible=false
		$ghostlayer/pastchar2/Girl5.visible=false
		$ghostlayer/pastchar2/Girl6.visible=false
		
		$ghostlayer/pastchar1/Boy.visible=false
		$ghostlayer/pastchar1/Girl.visible=false
		$"ghostlayer/pastchar1/YN label".visible=false
		$ghostlayer/pastchar1/Label.visible=false
		$ghostlayer/pastchar1/skip.visible=false
		
		$ghostlayer/ghosttext/Label2.visible=false
		$ghostlayer/ghosttext/GirlGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost2.visible=false
		$ghostlayer/ghosttext/GirlGhost2.visible=false
		$ghostlayer/ghosttext/skip.visible=false
		
		$ghostlayer/ghosttext2/Label3.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost2.visible=false
		$ghostlayer/ghosttext2/GirlGhost2.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		
		$ghostlayer/ghosttext3/Label6.visible=false
		$ghostlayer/ghosttext3/BoyGhost.visible=false
		$ghostlayer/ghosttext3/GirlGhost.visible=false
		$ghostlayer/ghosttext3/skip.visible=false
		
		$ghostlayer/ghosttext4/Label4.visible=false
		$ghostlayer/ghosttext4/GirlGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost2.visible=false
		$ghostlayer/ghosttext4/GirlGhost2.visible=false
		$ghostlayer/ghosttext4/skip.visible=false
		
		$ghostlayer/ghosttext5/Label6.visible=false
		$ghostlayer/ghosttext5/skip.visible=false
		$ghostlayer/ghosttext5/BoyGhost2.visible=false
		$ghostlayer/ghosttext5/GirlGhost2.visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
			
	if anim_index == 6:
		$ghostlayer/bedroomfailghost/Label.visible=false
		$ghostlayer/bedroomfailghost/GirlGhost.visible=false
		$ghostlayer/bedroomfailghost/BoyGhost.visible=false
		$ghostlayer/bedroomfailghost/skip.visible=false
		
		$"ghostlayer/pastchar2/Ex label".visible=false
		$ghostlayer/pastchar2/Label3.visible=false
		$ghostlayer/pastchar2/skip.visible=false
		$"ghostlayer/pastchar2/YN label".visible=false
		$ghostlayer/pastchar2/Boy1.visible=false
		$ghostlayer/pastchar2/Boy2.visible=false
		$ghostlayer/pastchar2/Boy3.visible=false
		$ghostlayer/pastchar2/Girl.visible=false
		$ghostlayer/pastchar2/Girl2.visible=false
		$ghostlayer/pastchar2/Girl3.visible=false
		$ghostlayer/pastchar2/Boy4.visible=false
		$ghostlayer/pastchar2/Boy5.visible=false
		$ghostlayer/pastchar2/Boy6.visible=false
		$ghostlayer/pastchar2/Girl4.visible=false
		$ghostlayer/pastchar2/Girl5.visible=false
		$ghostlayer/pastchar2/Girl6.visible=false
		
		$ghostlayer/pastchar1/Boy.visible=false
		$ghostlayer/pastchar1/Girl.visible=false
		$"ghostlayer/pastchar1/YN label".visible=false
		$ghostlayer/pastchar1/Label.visible=false
		$ghostlayer/pastchar1/skip.visible=false
		
		$ghostlayer/ghosttext/Label2.visible=false
		$ghostlayer/ghosttext/GirlGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost2.visible=false
		$ghostlayer/ghosttext/GirlGhost2.visible=false
		$ghostlayer/ghosttext/skip.visible=false
		
		$ghostlayer/ghosttext2/Label3.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost2.visible=false
		$ghostlayer/ghosttext2/GirlGhost2.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		
		$ghostlayer/ghosttext3/Label6.visible=false
		$ghostlayer/ghosttext3/BoyGhost.visible=false
		$ghostlayer/ghosttext3/GirlGhost.visible=false
		$ghostlayer/ghosttext3/skip.visible=false
		
		$ghostlayer/ghosttext4/Label4.visible=false
		$ghostlayer/ghosttext4/GirlGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost2.visible=false
		$ghostlayer/ghosttext4/GirlGhost2.visible=false
		$ghostlayer/ghosttext4/skip.visible=false
		
		$ghostlayer/ghosttext5/Label6.visible=false
		$ghostlayer/ghosttext5/skip.visible=false
		$ghostlayer/ghosttext5/BoyGhost2.visible=false
		$ghostlayer/ghosttext5/GirlGhost2.visible=false
		
		$ghostlayer/ghosttext6/Label4.visible=false
		$ghostlayer/ghosttext6/GirlGhost.visible=false
		$ghostlayer/ghosttext6/BoyGhost.visible=false
		$ghostlayer/ghosttext6/skip.visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
			
	if anim_index == 7:
		$ghostlayer/bedroomfailghost/Label.visible=false
		$ghostlayer/bedroomfailghost/GirlGhost.visible=false
		$ghostlayer/bedroomfailghost/BoyGhost.visible=false
		$ghostlayer/bedroomfailghost/skip.visible=false

		$ghostlayer/pastchar1/Boy.visible=false
		$ghostlayer/pastchar1/Girl.visible=false
		$"ghostlayer/pastchar1/YN label".visible=false
		$ghostlayer/pastchar1/Label.visible=false
		$ghostlayer/pastchar1/skip.visible=false
		
		$ghostlayer/ghosttext/Label2.visible=false
		$ghostlayer/ghosttext/GirlGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost2.visible=false
		$ghostlayer/ghosttext/GirlGhost2.visible=false
		$ghostlayer/ghosttext/skip.visible=false
		
		$ghostlayer/ghosttext2/Label3.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost2.visible=false
		$ghostlayer/ghosttext2/GirlGhost2.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		
		$ghostlayer/ghosttext3/Label6.visible=false
		$ghostlayer/ghosttext3/BoyGhost.visible=false
		$ghostlayer/ghosttext3/GirlGhost.visible=false
		$ghostlayer/ghosttext3/skip.visible=false
		
		$ghostlayer/ghosttext4/Label4.visible=false
		$ghostlayer/ghosttext4/GirlGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost2.visible=false
		$ghostlayer/ghosttext4/GirlGhost2.visible=false
		$ghostlayer/ghosttext4/skip.visible=false
		
		$ghostlayer/ghosttext5/Label6.visible=false
		$ghostlayer/ghosttext5/skip.visible=false
		$ghostlayer/ghosttext5/BoyGhost2.visible=false
		$ghostlayer/ghosttext5/GirlGhost2.visible=false
		
		$ghostlayer/ghosttext6/Label4.visible=false
		$ghostlayer/ghosttext6/GirlGhost.visible=false
		$ghostlayer/ghosttext6/BoyGhost.visible=false
		$ghostlayer/ghosttext6/skip.visible=false
		
		$ghostlayer/ghosttext7/Label5.visible=false
		$ghostlayer/ghosttext7/GirlGhost.visible=false
		$ghostlayer/ghosttext7/BoyGhost.visible=false
		$ghostlayer/ghosttext7/skip.visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	
	if anim_index == 8:
		$ghostlayer/bedroomfailghost/Label.visible=false
		$ghostlayer/bedroomfailghost/GirlGhost.visible=false
		$ghostlayer/bedroomfailghost/BoyGhost.visible=false
		$ghostlayer/bedroomfailghost/skip.visible=false
			
		$ghostlayer/pastchar1/Boy.visible=false
		$ghostlayer/pastchar1/Girl.visible=false
		$"ghostlayer/pastchar1/YN label".visible=false
		$ghostlayer/pastchar1/Label.visible=false
		$ghostlayer/pastchar1/skip.visible=false
		
		$ghostlayer/ghosttext/Label2.visible=false
		$ghostlayer/ghosttext/GirlGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost2.visible=false
		$ghostlayer/ghosttext/GirlGhost2.visible=false
		$ghostlayer/ghosttext/skip.visible=false
		
		$ghostlayer/ghosttext2/Label3.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost2.visible=false
		$ghostlayer/ghosttext2/GirlGhost2.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		
		$ghostlayer/ghosttext3/Label6.visible=false
		$ghostlayer/ghosttext3/BoyGhost.visible=false
		$ghostlayer/ghosttext3/GirlGhost.visible=false
		$ghostlayer/ghosttext3/skip.visible=false
		
		$ghostlayer/ghosttext4/Label4.visible=false
		$ghostlayer/ghosttext4/GirlGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost2.visible=false
		$ghostlayer/ghosttext4/GirlGhost2.visible=false
		$ghostlayer/ghosttext4/skip.visible=false
		
		$ghostlayer/ghosttext5/Label6.visible=false
		$ghostlayer/ghosttext5/skip.visible=false
		$ghostlayer/ghosttext5/BoyGhost2.visible=false
		$ghostlayer/ghosttext5/GirlGhost2.visible=false
		
		$ghostlayer/ghosttext6/Label4.visible=false
		$ghostlayer/ghosttext6/GirlGhost.visible=false
		$ghostlayer/ghosttext6/BoyGhost.visible=false
		$ghostlayer/ghosttext6/skip.visible=false
		
		$ghostlayer/ghosttext7/Label5.visible=false
		$ghostlayer/ghosttext7/GirlGhost.visible=false
		$ghostlayer/ghosttext7/BoyGhost.visible=false
		$ghostlayer/ghosttext7/skip.visible=false
		
		$ghostlayer/pastchar1/Boy.visible=false
		$ghostlayer/pastchar1/Girl.visible=false
		$"ghostlayer/pastchar1/YN label".visible=false
		$ghostlayer/pastchar1/Label.visible=false
		$ghostlayer/pastchar1/skip.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
			
	if anim_index == 9:
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
		$ghostlayer/ghosttext/Label2.visible=false
		$ghostlayer/ghosttext/GirlGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost.visible=false
		$ghostlayer/ghosttext/BoyGhost2.visible=false
		$ghostlayer/ghosttext/GirlGhost2.visible=false
		$ghostlayer/ghosttext/skip.visible=false
			
	if anim_index ==1:
		$ghostlayer/ghosttext2/Label3.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost2.visible=false
		$ghostlayer/ghosttext2/GirlGhost2.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		
	if anim_index ==2:
		$ghostlayer/ghosttext3/Label6.visible=false
		$ghostlayer/ghosttext3/BoyGhost.visible=false
		$ghostlayer/ghosttext3/GirlGhost.visible=false
		$ghostlayer/ghosttext3/skip.visible=false
		
	if anim_index == 3:
		$ghostlayer/ghosttext4/Label4.visible=false
		$ghostlayer/ghosttext4/GirlGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost2.visible=false
		$ghostlayer/ghosttext4/GirlGhost2.visible=false
		$ghostlayer/ghosttext4/skip.visible=false
		
	if anim_index == 4:
		$ghostlayer/ghosttext5/Label6.visible=false
		$ghostlayer/ghosttext5/skip.visible=false
		$ghostlayer/ghosttext5/BoyGhost2.visible=false
		$ghostlayer/ghosttext5/GirlGhost2.visible=false
		
	if anim_index == 5:
		$ghostlayer/ghosttext6/Label4.visible=false
		$ghostlayer/ghosttext6/GirlGhost.visible=false
		$ghostlayer/ghosttext6/BoyGhost.visible=false
		$ghostlayer/ghosttext6/skip.visible=false
		
	if anim_index == 6:
		$ghostlayer/ghosttext7/Label5.visible=false
		$ghostlayer/ghosttext7/GirlGhost.visible=false
		$ghostlayer/ghosttext7/BoyGhost.visible=false
		$ghostlayer/ghosttext7/skip.visible=false
	
	if anim_index == 7:
		$ghostlayer/pastchar1/Boy.visible=false
		$ghostlayer/pastchar1/Girl.visible=false
		$"ghostlayer/pastchar1/YN label".visible=false
		$ghostlayer/pastchar1/Label.visible=false
		$ghostlayer/pastchar1/skip.visible=false
		
	if anim_index == 8:
		$ghostlayer/pastchar2/Label3.visible=false
		$ghostlayer/pastchar2/skip.visible=false
		$"ghostlayer/pastchar2/YN label".visible=false
		$ghostlayer/pastchar2/Boy1.visible=false
		$ghostlayer/pastchar2/Boy2.visible=false
		$ghostlayer/pastchar2/Boy3.visible=false
		$ghostlayer/pastchar2/Girl.visible=false
		$ghostlayer/pastchar2/Girl2.visible=false
		$ghostlayer/pastchar2/Girl3.visible=false
		$ghostlayer/pastchar2/Boy4.visible=false
		$ghostlayer/pastchar2/Boy5.visible=false
		$ghostlayer/pastchar2/Boy6.visible=false
		$ghostlayer/pastchar2/Girl4.visible=false
		$ghostlayer/pastchar2/Girl5.visible=false
		$ghostlayer/pastchar2/Girl6.visible=false
		$"ghostlayer/pastchar2/Ex label".visible=false
		
	if anim_index == 9:
		$ghostlayer/bedroomfailghost/Label.visible=false
		$ghostlayer/bedroomfailghost/GirlGhost.visible=false
		$ghostlayer/bedroomfailghost/BoyGhost.visible=false
		$ghostlayer/bedroomfailghost/skip.visible=false
		
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


func text():
	await start_dialogue(0)
	await atticmodulate()
	await start_dialogue(7)
	$ghostlayer/idle/girl.visible=false
	$ghostlayer/idle/boy.visible=false
	$ghostlayer/AnimationPlayer.play("death")
	$ghostlayer/Camera2D.shake(2, 1.4)
	await $ghostlayer/AnimationPlayer.animation_finished
	$ghostlayer/Bloodblanket.visible=true
	await start_dialogue(1)
	$ghostlayer/explorelabel.visible=true
	unlockexplore()

	
func atticmodulate():
	##past char in modulations
	$ghostlayer/Camera2D.shake(2, 1.4)
	if Global.character =="boyGhost":
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		pastbox()
		$ghostlayer/idle/boy.visible=true
		$ghostlayer/Bloodblanket.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
		$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
		presentbox()
		$ghostlayer/idle/boy.visible=false
		$ghostlayer/Bloodblanket.visible=true
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		pastbox()
		$ghostlayer/Bloodblanket.visible=false
		$ghostlayer/idle/boy.visible=true
		
	if Global.character =="girlGhost":
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		presentbox()
		$ghostlayer/idle/girl.visible=true
		$ghostlayer/Bloodblanket.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
		$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
		pastbox()
		$ghostlayer/idle/girl.visible=false
		$ghostlayer/Bloodblanket.visible=true
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		presentbox()
		$ghostlayer/Bloodblanket.visible=false
		$ghostlayer/idle/girl.visible=true


func unlockexplore():
	$ghostlayer/explorelabel.visible=true
	$explore/CanvasLayer/box/CollisionShape2D.disabled=false
	$explore/CanvasLayer/box/CollisionShape2D2.disabled=false
	$explore/CanvasLayer/box/CollisionShape2D3.disabled=false
	$explore/CanvasLayer/box/CollisionShape2D4.disabled=false
	$explore/CanvasLayer/box/CollisionShape2D5.disabled=false
	$explore/CanvasLayer/box/CollisionShape2D6.disabled=false
	$explore/CanvasLayer/box/CollisionShape2D7.disabled=false
	$explore/CanvasLayer/box/CollisionShape2D8.disabled=false
	$explore/CanvasLayer/box/CollisionShape2D9.disabled=false
	$explore/CanvasLayer/box/CollisionShape2D10.disabled=false
	$explore/CanvasLayer/box/CollisionShape2D11.disabled=false
	$explore/CanvasLayer/box/CollisionShape2D12.disabled=false
	$explore/CanvasLayer/window/CollisionShape2D.disabled=false
	$explore/CanvasLayer/blanket/CollisionShape2D.disabled=false
	
	var areas = {
		"window": $explore/CanvasLayer/window,
		"blanket": $explore/CanvasLayer/blanket,
		"box": $explore/CanvasLayer/box,

		
	}
	for name in areas:
		var area_node = areas[name]

		if area_node is Area2D:
			area_node.clicked.connect(
				func(text):
					_on_object_clicked(text, name)
			)
			
var is_interacting = false

func _on_object_clicked(text: String, area_name: String):
	
	# Immediately update label for any object
	narration_label.text = text
	narration_label.visible = true

	# Mark this object as clicked
	if not clicked_objects.has(area_name):
		clicked_objects[area_name] = true

	# If box clicked but not all others, show message and skip sequence
	if area_name == "box" and not all_non_photos_clicked():
		narration_label.text = "Let's finish looking at everything else first."
		narration_label.visible = true
		reset_timer.start() 
		return

	# Full box sequence after all other objects clicked
	if area_name == "box" and all_non_photos_clicked():
		print("yes")
		narration_label.visible=false
		$explore/CanvasLayer/box/CollisionShape2D.disabled = true
		$explore/CanvasLayer/box/CollisionShape2D2.disabled = true
		$explore/CanvasLayer/box/CollisionShape2D3.disabled = true
		$explore/CanvasLayer/box/CollisionShape2D4.disabled = true
		$explore/CanvasLayer/box/CollisionShape2D5.disabled = true
		$explore/CanvasLayer/box/CollisionShape2D6.disabled = true
		$explore/CanvasLayer/box/CollisionShape2D7.disabled = true
		$explore/CanvasLayer/box/CollisionShape2D8.disabled = true
		$explore/CanvasLayer/box/CollisionShape2D9.disabled = true
		$explore/CanvasLayer/box/CollisionShape2D10.disabled = true
		$explore/CanvasLayer/box/CollisionShape2D11.disabled = true
		$explore/CanvasLayer/box/CollisionShape2D12.disabled = true
		$explore/CanvasLayer/window/CollisionShape2D.disabled = true
		$explore/CanvasLayer/blanket/CollisionShape2D.disabled = true

		$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28)
		$CanvasLayer2/CanvasModulate.color = Color(0.0, 0.992, 0.816)
		presentbox()
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
		pastbox()
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28)
		$CanvasLayer2/CanvasModulate.color = Color(0.0, 0.992, 0.816)
		presentbox()
		await start_dialogue(2)
		challenge()

	reset_timer.start()
		
func _on_reset_timeout():
	if not is_interacting:
		narration_label.text = "Interact with objects arround the attic to investigate."
		
func all_non_photos_clicked() -> bool:
	var non_desk = ["blanket", "window"]
	for name in non_desk:
		if not clicked_objects.has(name): 
			return false
	return true


func afterpuzzle():
	#past char and then ex walk in close but not too close
	if Global.character == "girlGhost":
		$ghostlayer/chars2girl.play("girl")
		await $ghostlayer/chars2girl.animation_finished
		await start_dialogue(8)
		$ghostlayer/chars2girl.play("kill")
		$ghostlayer/idle/girl.visible=false
		await $ghostlayer/chars2girl.animation_finished
		$ghostlayer/Bloodblanket.visible=true
			
	if Global.character == "boyGhost":
		$ghostlayer/chars2boy.play("boy")
		await $ghostlayer/chars2boy.animation_finished
		await start_dialogue(8)
		$ghostlayer/idle/boy.visible=false
		$ghostlayer/chars2boy.play("death")
		await $ghostlayer/chars2boy.animation_finished
		$ghostlayer/Bloodblanket.visible=true
	#after animation finished, ex comes in closer fast so it looks like stab,
	#then it'll go to the screen with blood on it 


func challenge():
	$ghostlayer/continue/CollisionShape2D.disabled=false
	$ghostlayer/ColorRect.visible=true
	$ghostlayer/Menucard.visible=true
	$ghostlayer/Label.visible=true
	$ghostlayer/Label2.visible=true
	$ghostlayer/Label3.visible=true
	$ghostlayer/continue.visible=true
	
	
func on_button_pressed():
	MusicManager.music_player.pitch_scale = 0.75
	MusicManager.play_scene_music("menu")
	$ghostlayer/Heart.visible=true
	$ghostlayer/Heart2.visible=true
	$ghostlayer/Heart3.visible=true
	$ghostlayer/Label9.visible=true
	$ghostlayer/Timer.visible=true
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
	$ghostlayer/past.visible=true
	$ghostlayer/past2.visible=true
	$explore/CanvasLayer/box/CollisionShape2D.disabled=true
	$explore/CanvasLayer/box/CollisionShape2D2.disabled=true
	$explore/CanvasLayer/box/CollisionShape2D3.disabled=true
	$explore/CanvasLayer/box/CollisionShape2D4.disabled=true
	$explore/CanvasLayer/box/CollisionShape2D5.disabled=true
	$explore/CanvasLayer/box/CollisionShape2D6.disabled=true
	$explore/CanvasLayer/box/CollisionShape2D7.disabled=true
	$explore/CanvasLayer/box/CollisionShape2D8.disabled=true
	$explore/CanvasLayer/box/CollisionShape2D9.disabled=true
	$explore/CanvasLayer/box/CollisionShape2D10.disabled=true
	$explore/CanvasLayer/box/CollisionShape2D11.disabled=true
	$explore/CanvasLayer/box/CollisionShape2D12.disabled=true
	$explore/CanvasLayer/window/CollisionShape2D.disabled=true
	$explore/CanvasLayer/blanket/CollisionShape2D.disabled=true
	pastbox()
	$ghostlayer/Timer2.start()
	$ghostlayer/Label8.visible=true
	await get_tree().create_timer(10).timeout
	$ghostlayer/past.visible=false
	$ghostlayer/past2.visible=false
	$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	$ghostlayer/Label8.visible=true
	$ghostlayer/present.visible=true
	$ghostlayer/present2.visible=true
	presentbox()
	$CanvasLayer/CanvasModulate/box2/box1/CollisionShape2D.disabled=false
	$CanvasLayer/CanvasModulate/box2/box2/CollisionShape2D.disabled=false
	$CanvasLayer/CanvasModulate/box2/box3/CollisionShape2D.disabled=false
	$CanvasLayer/CanvasModulate/box2/box4/CollisionShape2D.disabled=false
	$CanvasLayer/CanvasModulate/box2/box5/CollisionShape2D.disabled=false
	$CanvasLayer/CanvasModulate/box2/box6/CollisionShape2D.disabled=false
	$CanvasLayer/CanvasModulate/box2/box7/CollisionShape2D.disabled=false
	$CanvasLayer/CanvasModulate/box2/box8/CollisionShape2D.disabled=false
	$CanvasLayer/CanvasModulate/box2/box9/CollisionShape2D.disabled=false
	$CanvasLayer/CanvasModulate/box2/box10/CollisionShape2D.disabled=false
	$CanvasLayer/CanvasModulate/box2/box11/CollisionShape2D.disabled=false
	$CanvasLayer/CanvasModulate/box2/box12/CollisionShape2D.disabled=false

func pastbox():
	$CanvasLayer/CanvasModulate/box/Box1.visible=true
	$CanvasLayer/CanvasModulate/box/Box2.visible=true
	$CanvasLayer/CanvasModulate/box/Box3.visible=true
	$CanvasLayer/CanvasModulate/box/Box4.visible=true
	$CanvasLayer/CanvasModulate/box/Box5.visible=true
	$CanvasLayer/CanvasModulate/box/Box6.visible=true
	$CanvasLayer/CanvasModulate/box/Box7.visible=true
	$CanvasLayer/CanvasModulate/box/Box8.visible=true
	$CanvasLayer/CanvasModulate/box/Box9.visible=true
	$CanvasLayer/CanvasModulate/box/Box10.visible=true
	$CanvasLayer/CanvasModulate/box/Box11.visible=true
	$CanvasLayer/CanvasModulate/box/Box12.visible=true
	
	
	$CanvasLayer/CanvasModulate/box2/box1.visible=false
	$CanvasLayer/CanvasModulate/box2/box2.visible=false
	$CanvasLayer/CanvasModulate/box2/box3.visible=false
	$CanvasLayer/CanvasModulate/box2/box4.visible=false
	$CanvasLayer/CanvasModulate/box2/box5.visible=false
	$CanvasLayer/CanvasModulate/box2/box6.visible=false
	$CanvasLayer/CanvasModulate/box2/box7.visible=false
	$CanvasLayer/CanvasModulate/box2/box8.visible=false
	$CanvasLayer/CanvasModulate/box2/box9.visible=false
	$CanvasLayer/CanvasModulate/box2/box10.visible=false
	$CanvasLayer/CanvasModulate/box2/box11.visible=false
	$CanvasLayer/CanvasModulate/box2/box12.visible=false
	
func presentbox():
	$CanvasLayer/CanvasModulate/box/Box1.visible=false
	$CanvasLayer/CanvasModulate/box/Box2.visible=false
	$CanvasLayer/CanvasModulate/box/Box3.visible=false
	$CanvasLayer/CanvasModulate/box/Box4.visible=false
	$CanvasLayer/CanvasModulate/box/Box5.visible=false
	$CanvasLayer/CanvasModulate/box/Box6.visible=false
	$CanvasLayer/CanvasModulate/box/Box7.visible=false
	$CanvasLayer/CanvasModulate/box/Box8.visible=false
	$CanvasLayer/CanvasModulate/box/Box9.visible=false
	$CanvasLayer/CanvasModulate/box/Box10.visible=false
	$CanvasLayer/CanvasModulate/box/Box11.visible=false
	$CanvasLayer/CanvasModulate/box/Box12.visible=false
	
	$CanvasLayer/CanvasModulate/box2/box1.visible=true
	$CanvasLayer/CanvasModulate/box2/box2.visible=true
	$CanvasLayer/CanvasModulate/box2/box3.visible=true
	$CanvasLayer/CanvasModulate/box2/box4.visible=true
	$CanvasLayer/CanvasModulate/box2/box5.visible=true
	$CanvasLayer/CanvasModulate/box2/box6.visible=true
	$CanvasLayer/CanvasModulate/box2/box7.visible=true
	$CanvasLayer/CanvasModulate/box2/box8.visible=true
	$CanvasLayer/CanvasModulate/box2/box9.visible=true
	$CanvasLayer/CanvasModulate/box2/box10.visible=true
	$CanvasLayer/CanvasModulate/box2/box11.visible=true
	$CanvasLayer/CanvasModulate/box2/box12.visible=true
	

func challengecompleted():
	MusicManager.music_player.pitch_scale = 0.75
	MusicManager.play_scene_music("menu")
	await get_tree().create_timer(2).timeout
	$ghostlayer/Heart.visible=false
	$ghostlayer/Heart2.visible=false
	$ghostlayer/Heart3.visible=false
	$ghostlayer/Heart4.visible=false
	$ghostlayer/Heart5.visible=false
	$ghostlayer/Heart6.visible=false
	$ghostlayer/Timer.visible=false
	$ghostlayer/Correct.visible=false
	$ghostlayer/Label8.visible=false
	$ghostlayer/present.visible=false
	$ghostlayer/present2.visible=false
	$ghostlayer/ColorRect.visible=true
	$ghostlayer/Label9.visible=false
	$ghostlayer/Diarypage.visible=true
	$ghostlayer/Label10.visible=true
	$ghostlayer/Label11.visible=true
	$ghostlayer/Label12.visible=true
	$ghostlayer/diarycontinue.visible=true
	$ghostlayer/diarycontinue/CollisionShape2D.disabled=false

func diarypagecontinue():
	$ghostlayer/diarycontinue.visible=false
	$ghostlayer/diarycontinue/CollisionShape2D.disabled=true
	$ghostlayer/ColorRect.visible=false
	$ghostlayer/Diarypage.visible=false
	$ghostlayer/Label10.visible=false
	$ghostlayer/Label11.visible=false
	$ghostlayer/Label12.visible=false
	$ghostlayer/Insidebox.visible=true
	$ghostlayer/Glove.visible=true
	$ghostlayer/Bloodblanket.visible=false
	await start_dialogue(3)
	$ghostlayer/Insidebox.visible=false
	$ghostlayer/Glove.visible=false
	#$ghostlayer/Label14.visible=true
	$ghostlayer/blobGhostPlayer.position.x=725
	$ghostlayer/blobGhostPlayer.position.y=737
	await atticmodulate()
	await afterpuzzle()
	$ghostlayer/AnimationPlayer.play("death")
	await $ghostlayer/AnimationPlayer.animation_finished
	await start_dialogue(4)
	$ghostlayer/ColorRect.visible=true
	$ghostlayer/choice.visible=true
	$ghostlayer/choice2.visible=true
	$ghostlayer/choice/CollisionShape2D.disabled=false
	$ghostlayer/choice2/CollisionShape2D.disabled=false
	
func choice1():
	Global.ending = 1
	$ghostlayer/ghosttext6/GirlGhost.visible=false
	$ghostlayer/ghosttext6/BoyGhost.visible=false
	$ghostlayer/choice.visible=false
	$ghostlayer/choice2.visible=false
	$ghostlayer/choice/CollisionShape2D.disabled=true
	$ghostlayer/choice2/CollisionShape2D.disabled=true
	$ghostlayer/ColorRect.visible=false
	await start_dialogue(5)
	var player = $ghostlayer/blobGhostPlayer
	await fade_out_node(player, 2.5)
	await get_tree().create_timer(0.5).timeout
	$ghostlayer/AnimationPlayer2.play("modulate")
	await $ghostlayer/AnimationPlayer2.animation_finished
	get_tree().change_scene_to_file("res://scenes/endcreds.tscn")

func choice2():
	Global.ending = 2
	$ghostlayer/ColorRect.visible=false
	$ghostlayer/ghosttext6/GirlGhost.visible=false
	$ghostlayer/ghosttext6/BoyGhost.visible=false
	$ghostlayer/choice.visible=false
	$ghostlayer/choice2.visible=false
	$ghostlayer/choice/CollisionShape2D.disabled=true
	$ghostlayer/choice2/CollisionShape2D.disabled=true
	await start_dialogue(6)
	$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	$ghostlayer/Label14.visible=true
	$ghostlayer/scenetrigger/CollisionShape2D.disabled=false
	$ghostlayer/Node2D/arrow.play("arrow")
	
	
func fade_out_node(node: CanvasItem, duration := 2.0) -> void:
	var elapsed := 0.0

	while elapsed < duration:
		elapsed += get_process_delta_time()
		var t := elapsed / duration
		node.modulate.a = lerp(1.0, 0.0, t)
		await get_tree().process_frame

	node.modulate.a = 0.0

	
