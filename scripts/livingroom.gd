extends Node2D


@onready var furniture = [
	$CanvasLayer/CanvasModulate/TileMap2,
	$CanvasLayer/CanvasModulate/TileMap,
	$CanvasLayer/CanvasModulate/Couch,
	$CanvasLayer/CanvasModulate/Clock,
	$CanvasLayer/CanvasModulate/Shelf,
	$CanvasLayer/CanvasModulate/Piano,
	$CanvasLayer/CanvasModulate/Flower,
	$CanvasLayer/CanvasModulate/Bluerug,
	$CanvasLayer/CanvasModulate/Coffeetable,
	$ghostlayer/Tv
]
@onready var doors = [
		$CanvasLayer/CanvasModulate/Door, 
		$CanvasLayer/CanvasModulate/Door2
]

@onready var narration_label: Label = $ghostlayer/explorelabel
@onready var explore_node: Node = $explore
var clicked_objects := {} 
var time_left_seconds

var segment_data := [
	{ "starts": [0.0, 4.0, 8.0], "ends": [2.0, 6.0, 10.0] }, 
	{ "starts": [0.0, 4.0, 8.0, 12.0,16.0, 20.0, 24.0], "ends": [2.0, 6.0, 10.0, 14.0, 18.0, 22.0, 26.0] },
	{ "starts": [0.0, 4.0, 8.0], "ends": [2.0, 6.0, 10.0] },
	{ "starts": [0.0, 4.0, 8.0], "ends": [2.0, 6.0, 10.0] }, 
	{ "starts": [0.0, 4.0, 8.0, 12.0], "ends": [2.0, 6.0, 10.0, 14.0] }, 
	{ "starts": [0.0], "ends": [2.0] }, #puzzle fail
	
]
@onready var anim_players := [
	$ghostlayer/ghosttext1,
	$ghostlayer/extext,
	$ghostlayer/ghosttext2,
	$ghostlayer/ghosttext3,
	$ghostlayer/ghosttext4,
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
@onready var reset_timer = $Timer

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
	reset_timer.timeout.connect(_on_reset_timeout)
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"
	#$ghostlayer/scentrigger/CollisionShape2D.disabled=false
	$CanvasLayer/AnimationPlayer/boy.visible = false
	$CanvasLayer/AnimationPlayer/girl.visible = false
	$CanvasLayer/AnimationPlayer/boySide.visible = false
	$CanvasLayer/AnimationPlayer/girlSide.visible = false
	$CanvasLayer/AnimationPlayer/boyDown.visible = false
	$CanvasLayer/AnimationPlayer/girlDown.visible = false
	$ghostlayer/Tv.visible=true
	for item in furniture:
		item.modulate = Color(0.0, 0.992, 0.816)
	for item in doors:
		item.modulate =Color( 0.094, 0.323, 0.28) 
	
	#Global.livingroomfail = true
	if Global.livingroomfail == true:
		$ghostlayer/bedroomfailghost/Label.text  = repeat_lines.pick_random()
		fade_out_music()
		$CanvasLayer5/failpuzzlecutscene/AnimationPlayer.play("text")
		await get_tree().create_timer(16).timeout
		await start_dialogue(5)
	else:
		MusicManager.music_player.pitch_scale = 1.0
		MusicManager.play_scene_music("menu")
	$diarypage/diarycontinue.diarypagecontinue.connect(diarypagecontinue)
	$ghostlayer/pianokeys.challengecompleted.connect(challengecompleted)
	$ghostlayer/continue.pressed.connect(pressed)
	#unlockexplore()
	await start_dialogue(0)
	await modulatelivingroom()
	
func _process(delta: float) -> void:
	time_left_seconds = $ghostlayer/Timer2.time_left
	$ghostlayer/Label8.text = "%.1f" % time_left_seconds
	$ghostlayer/Label8.add_theme_color_override("font_color", Color(0,0,0))
	
	
	var timer = $ghostlayer/Timer2
	
	if time_left_seconds < 11.0:
			if int(Time.get_ticks_msec() / 300) % 3 == 0:
				$ghostlayer/Label8.add_theme_color_override("font_color", Color(1,0,0))
			else:
				$ghostlayer/Label8.add_theme_color_override("font_color", Color(0,0,0))

	if not timer.is_stopped():
		var t = timer.time_left / timer.wait_time
		MusicManager.music_player.pitch_scale = lerp(1.0, 0.75, t)
	
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
		
		$ghostlayer/ghosttext1/skip.visible=false
		$ghostlayer/ghosttext1/Label3.visible=false
		$ghostlayer/ghosttext1/BoyGhost.visible=false
		$ghostlayer/ghosttext1/GirlGhost.visible=false
		
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
		
		$ghostlayer/ghosttext1/skip.visible=false
		$ghostlayer/ghosttext1/Label3.visible=false
		$ghostlayer/ghosttext1/BoyGhost.visible=false
		$ghostlayer/ghosttext1/GirlGhost.visible=false
		
		$"ghostlayer/extext/YN label".visible=false
		$ghostlayer/extext/Label7.visible=false
		$ghostlayer/extext/skip.visible=false
		$ghostlayer/extext/Boy1.visible=false
		$ghostlayer/extext/Boy2.visible=false
		$ghostlayer/extext/Boy3.visible=false
		$ghostlayer/extext/Girl.visible=false
		$ghostlayer/extext/Girl2.visible=false
		$ghostlayer/extext/Girl3.visible=false
		$ghostlayer/extext/Boy4.visible=false
		$ghostlayer/extext/Boy5.visible=false
		$ghostlayer/extext/Boy6.visible=false
		$ghostlayer/extext/Girl4.visible=false
		$ghostlayer/extext/Girl5.visible=false
		$ghostlayer/extext/Girl6.visible=false
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
		
		$ghostlayer/ghosttext1/skip.visible=false
		$ghostlayer/ghosttext1/Label3.visible=false
		$ghostlayer/ghosttext1/BoyGhost.visible=false
		$ghostlayer/ghosttext1/GirlGhost.visible=false
		
		$"ghostlayer/extext/YN label".visible=false
		$ghostlayer/extext/Label7.visible=false
		$ghostlayer/extext/skip.visible=false
		$ghostlayer/extext/Boy1.visible=false
		$ghostlayer/extext/Boy2.visible=false
		$ghostlayer/extext/Boy3.visible=false
		$ghostlayer/extext/Girl.visible=false
		$ghostlayer/extext/Girl2.visible=false
		$ghostlayer/extext/Girl3.visible=false
		$ghostlayer/extext/Boy4.visible=false
		$ghostlayer/extext/Boy5.visible=false
		$ghostlayer/extext/Boy6.visible=false
		$ghostlayer/extext/Girl4.visible=false
		$ghostlayer/extext/Girl5.visible=false
		$ghostlayer/extext/Girl6.visible=false
		
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		$ghostlayer/ghosttext2/Label3.visible=false
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
		
		$ghostlayer/ghosttext1/skip.visible=false
		$ghostlayer/ghosttext1/Label3.visible=false
		$ghostlayer/ghosttext1/BoyGhost.visible=false
		$ghostlayer/ghosttext1/GirlGhost.visible=false
		
		$"ghostlayer/extext/YN label".visible=false
		$ghostlayer/extext/Label7.visible=false
		$ghostlayer/extext/skip.visible=false
		$ghostlayer/extext/Boy1.visible=false
		$ghostlayer/extext/Boy2.visible=false
		$ghostlayer/extext/Boy3.visible=false
		$ghostlayer/extext/Girl.visible=false
		$ghostlayer/extext/Girl2.visible=false
		$ghostlayer/extext/Girl3.visible=false
		$ghostlayer/extext/Boy4.visible=false
		$ghostlayer/extext/Boy5.visible=false
		$ghostlayer/extext/Boy6.visible=false
		$ghostlayer/extext/Girl4.visible=false
		$ghostlayer/extext/Girl5.visible=false
		$ghostlayer/extext/Girl6.visible=false
		
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		$ghostlayer/ghosttext2/Label3.visible=false
		
		$ghostlayer/ghosttext3/Label3.visible=false
		$ghostlayer/ghosttext3/skip.visible=false
		$ghostlayer/ghosttext3/BoyGhost.visible=false
		$ghostlayer/ghosttext3/GirlGhost.visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	
	if anim_index == 5:
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
		$ghostlayer/ghosttext1/skip.visible=false
		$ghostlayer/ghosttext1/Label3.visible=false
		$ghostlayer/ghosttext1/BoyGhost.visible=false
		$ghostlayer/ghosttext1/GirlGhost.visible=false
			
	if anim_index ==1:
		$"ghostlayer/extext/YN label".visible=false
		$ghostlayer/extext/Label7.visible=false
		$ghostlayer/extext/skip.visible=false
		$ghostlayer/extext/Boy1.visible=false
		$ghostlayer/extext/Boy2.visible=false
		$ghostlayer/extext/Boy3.visible=false
		$ghostlayer/extext/Girl.visible=false
		$ghostlayer/extext/Girl2.visible=false
		$ghostlayer/extext/Girl3.visible=false
		$ghostlayer/extext/Boy4.visible=false
		$ghostlayer/extext/Boy5.visible=false
		$ghostlayer/extext/Boy6.visible=false
		$ghostlayer/extext/Girl4.visible=false
		$ghostlayer/extext/Girl5.visible=false
		$ghostlayer/extext/Girl6.visible=false
	
	if anim_index == 2:
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		$ghostlayer/ghosttext2/Label3.visible=false
		
	if anim_index == 3:
		$ghostlayer/ghosttext3/Label3.visible=false
		$ghostlayer/ghosttext3/skip.visible=false
		$ghostlayer/ghosttext3/BoyGhost.visible=false
		$ghostlayer/ghosttext3/GirlGhost.visible=false
	
	if anim_index == 4:
		$ghostlayer/ghosttext4/GirlGhost.visible=false
		$ghostlayer/ghosttext4/BoyGhost.visible=false
		$ghostlayer/ghosttext4/Label4.visible=false
		$ghostlayer/ghosttext4/Auntletter2.visible=false
		$ghostlayer/ghosttext4/skip.visible=false
		$ghostlayer/ghosttext4/Auntletter.visible=false
		
	if anim_index == 5:
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


func modulatelivingroom():
	$ghostlayer/Camera2D.shake(2, 0.8)
	for item in furniture:
		item.modulate = Color(1, 1, 1, 1)
	for item in doors:
		item.modulate =Color(1,1,1,1) 
	$CanvasLayer/AnimationPlayer/boy.visible = true
	$CanvasLayer/AnimationPlayer/girl.visible = true
	await get_tree().create_timer(0.5).timeout
	for item in furniture:
		item.modulate = Color(0.0, 0.992, 0.816)
	for item in doors:
		item.modulate =Color( 0.094, 0.323, 0.28) 
	$CanvasLayer/AnimationPlayer/boy.visible = false
	$CanvasLayer/AnimationPlayer/girl.visible = false
	await get_tree().create_timer(0.5).timeout
	for item in furniture:
		item.modulate = Color(1, 1, 1, 1)
	for item in doors:
		item.modulate =Color(1,1,1,1) 
	$CanvasLayer/AnimationPlayer/boy.visible = true
	$CanvasLayer/AnimationPlayer/girl.visible = true
	await start_dialogue(1)
	$CanvasLayer/AnimationPlayer.play("exit")
	await $CanvasLayer/AnimationPlayer.animation_finished
	await start_dialogue(2)
	$ghostlayer/explorelabel.visible=true
	unlockexplore()

func _on_reset_timeout():
	narration_label.text = "Interact with objects around the living room to investigate."
	
var is_interacting = false

func unlockexplore():
	$ghostlayer/explorelabel.visible=true
	$explore/bookshelf/CollisionShape2D.disabled=false
	$explore/clock/CollisionShape2D.disabled=false
	$explore/couch/CollisionShape2D.disabled=false
	$explore/table/CollisionShape2D.disabled=false
	$explore/tv/CollisionShape2D.disabled=false
	$explore/rug/CollisionShape2D.disabled=false
	$explore/flower/CollisionShape2D.disabled=false
	$explore/piano/CollisionShape2D.disabled=false
	
	var areas = {
		"bookshelf": $explore/bookshelf,
		"clock": $explore/clock,
		"couch": $explore/couch,
		"table": $explore/table,
		"tv": $explore/tv,
		"rug": $explore/rug,
		"flower": $explore/flower,
		"piano": $explore/piano,
		
	}

	for name in areas:
		var area_node = areas[name]
		var area_name = name  # capture safely

		if area_node is Area2D:
			area_node.clicked.connect(
				func(text):
					_on_object_clicked(text, area_name)
			)
			
func _on_object_clicked(text: String, area_name: String):
# Immediately update label for any object
	narration_label.text = text
	narration_label.visible = true

	# Mark this object as clicked
	if not clicked_objects.has(area_name):
		clicked_objects[area_name] = true


	if area_name == "piano" and not all_non_photos_clicked():
		narration_label.text = "Let's finish looking at everything else first."
		narration_label.visible = true
		reset_timer.start()
		await reset_timer.timeout
		is_interacting = false
		return

	if area_name == "piano" and all_non_photos_clicked():
		narration_label.visible = false
		challenge()
		return

	reset_timer.start()


func all_non_photos_clicked() -> bool:
	var non_desk = ["bookshelf", "clock", "table", "couch", "tv", "flower", "rug"]
	for name in non_desk:
		if not clicked_objects.has(name): 
			return false
	return true

func challenge():
	$ghostlayer/explorelabel.visible=false
	$ghostlayer/Tv.visible=false
	$explore/bookshelf/CollisionShape2D.disabled=true
	$explore/clock/CollisionShape2D.disabled=true
	$explore/couch/CollisionShape2D.disabled=true
	$explore/table/CollisionShape2D.disabled=true
	$explore/tv/CollisionShape2D.disabled=true
	$explore/rug/CollisionShape2D.disabled=true
	$explore/flower/CollisionShape2D.disabled=true
	$explore/piano/CollisionShape2D.disabled=true
	$ghostlayer/Music.visible=true
	$ghostlayer/Label.visible=true
	$ghostlayer/Label2.visible=true
	$ghostlayer/Label3.visible=true
	$ghostlayer/Label4.visible=true
	await start_dialogue(3)
	$ghostlayer/ColorRect.visible=true
	$ghostlayer/Menucard.visible=true
	$ghostlayer/Label5.visible=true
	$ghostlayer/Label6.visible=true
	$ghostlayer/Label7.visible=true
	$ghostlayer/continue.visible=true
	$ghostlayer/continue/CollisionShape2D.disabled=false

func pressed():
	MusicManager.play_scene_music("puzzle2")
	MusicManager.music_player.pitch_scale = 0.75
	if Global.hardmode:
		if Global.hearts == 3:
			$ghostlayer/Heart.visible=true
			$ghostlayer/Heart2.visible=true
			$ghostlayer/Heart3.visible=true
		elif Global.hearts ==2:
			$ghostlayer/Heart.visible=true
			$ghostlayer/Heart2.visible=true
			$ghostlayer/Heart6.visible=true
		else:
			$ghostlayer/Heart.visible=true
			$ghostlayer/Heart5.visible=true
			$ghostlayer/Heart6.visible=true
	else:	
		$ghostlayer/Heart.visible=true
		$ghostlayer/Heart2.visible=true
		$ghostlayer/Heart3.visible=true
	$ghostlayer/Label9.visible=true
	$ghostlayer/Label.visible=true
	$ghostlayer/Label2.visible=true
	$ghostlayer/Label3.visible=true
	$ghostlayer/Label4.visible=true
	$ghostlayer/Label8.visible=true
	$ghostlayer/ColorRect.visible=false
	$ghostlayer/Menucard.visible=false
	$ghostlayer/Label5.visible=false
	$ghostlayer/Label6.visible=false
	$ghostlayer/Label7.visible=false
	$ghostlayer/continue.visible=false
	$ghostlayer/Timer.visible=true
	$ghostlayer/Timer2.start()
	$ghostlayer/pianokeys/CollisionShape2D.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D2.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D3.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D4.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D5.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D6.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D7.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D8.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D9.disabled=false
	
func challengecompleted():
	$ghostlayer/Heart.visible=false
	$ghostlayer/Heart2.visible=false
	$ghostlayer/Heart3.visible=false
	$ghostlayer/Heart4.visible=false
	$ghostlayer/Heart5.visible=false
	$ghostlayer/Heart6.visible=false
	MusicManager.music_player.pitch_scale = 1.0
	MusicManager.play_scene_music("menu")
	$ghostlayer/Label.visible=false
	$ghostlayer/Label2.visible=false
	$ghostlayer/Label3.visible=false
	$ghostlayer/Label4.visible=false
	$ghostlayer/Label9.visible=false
	$explore/bookshelf/CollisionShape2D.disabled=true
	$explore/clock/CollisionShape2D.disabled=true
	$explore/couch/CollisionShape2D.disabled=true
	$explore/table/CollisionShape2D.disabled=true
	$explore/tv/CollisionShape2D.disabled=true
	$explore/rug/CollisionShape2D.disabled=true
	$explore/flower/CollisionShape2D.disabled=true
	$explore/piano/CollisionShape2D.disabled=true
	$ghostlayer/pianokeys/CollisionShape2D6/ColorRect.visible=false
	$ghostlayer/Correct.visible=false
	$diarypage.visible=true
	$diarypage/diarycontinue/CollisionShape2D.disabled=false

func diarypagecontinue():
	$diarypage.visible=false
	$diarypage/diarycontinue/CollisionShape2D.disabled=true
	$ghostlayer/blobGhostPlayer.position.x = 2128
	$ghostlayer/blobGhostPlayer.position.y = 399
	await start_dialogue(4)
	$ghostlayer/Tv.visible=true
	$ghostlayer/blobGhostPlayer.position.x = 2128
	$ghostlayer/blobGhostPlayer.position.y = 399
	$ghostlayer/Music.visible=false
	$ghostlayer/Music2.visible=false
	$ghostlayer/Music3.visible=false
	$ghostlayer/Camera2D.shake(1.8, 1.4)
	for item in furniture:
		item.modulate = Color(0.0, 0.992, 0.816)
	for item in doors:
		item.modulate =Color( 0.094, 0.323, 0.28) 
	await get_tree().create_timer(0.5).timeout
	for item in furniture:
		item.modulate = Color(1,1,1,1)
	for item in doors:
		item.modulate =Color( 1,1,1,1) 
	await get_tree().create_timer(0.5).timeout
	for item in furniture:
		item.modulate = Color(0.0, 0.992, 0.816)
	for item in doors:
		item.modulate =Color( 0.094, 0.323, 0.28) 
	$ghostlayer/scentrigger/CollisionShape2D.disabled=false
	await get_tree().create_timer(0.4).timeout
	$ghostlayer/Label14.visible=true
	$ghostlayer/Node2D/arrow.play("arrow")
