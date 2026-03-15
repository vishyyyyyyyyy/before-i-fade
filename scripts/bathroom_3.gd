extends Node2D

var segment_data := [
	{ "starts": [0.0], "ends": [2.0] }, #ghost enter bathroom
	{ "starts": [0.0, 4.0, 8.0, 12.0], "ends": [2.0, 6.0, 10.0, 14.0] }, #friend phone call
	{ "starts": [0.0, 4.0, 8.0, 12.0, 20.0], "ends": [2.0, 6.0, 10.0, 16.0, 24.0] }, #ghost say friend annoying
	{ "starts": [0.0, 4.0, 8.0], "ends": [2.0, 6.0, 10.0] }, #find comb
	{ "starts": [0.0], "ends": [2.0] }, #fail puzzle
]
@onready var anim_players := [
	$CanvasLayer3/ghosttalk, #ghost enter bathroom
	$CanvasLayer3/friendphone ,
	$CanvasLayer3/ghosttalk2,
	$CanvasLayer3/ghosttalk3,  #find comb
	$CanvasLayer3/bedroomfailghost # fail 
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Global.bathroomfail = true
	if Global.bathroomfail == true:
		$CanvasLayer3/bedroomfailghost/Label.text  = repeat_lines.pick_random()
		fade_out_music()
		$CanvasLayer3/failpuzzlecutscene/AnimationPlayer.play("text")
		await get_tree().create_timer(16).timeout
		await start_dialogue(4)
	else:
		MusicManager.music_player.pitch_scale = 1.0
		MusicManager.play_scene_music("menu")
	$CanvasLayer3/diarycontinue.diarypagecontinue.connect(diarypagecontinue)
	$CanvasLayer3/AnimationPlayer/girlWalk.visible = false
	$CanvasLayer3/AnimationPlayer/boyWalk.visible = false
	if (Global.character == "girlGhost"):
		$CanvasLayer3/AnimationPlayer/girl.visible = false
	if (Global.character == "boyGhost"):
		$CanvasLayer3/AnimationPlayer/boy.visible = false
	Global.reusabledesk =1
	print(Global.reusabledesk)
	await start_dialogue(0)
	await get_tree().create_timer(1).timeout
	if (Global.character == "girlGhost"):
		$CanvasLayer3/AnimationPlayer/girl.visible = true
	if (Global.character == "boyGhost"):
		$CanvasLayer3/AnimationPlayer/boy.visible = true
	$CanvasLayer/TileMap.visible=false
	$CanvasLayer3/Camera2D.shake(2, 1.4)
	$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
	$CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	if (Global.character == "girlGhost"):
		$CanvasLayer3/AnimationPlayer/girl.visible = false
	if (Global.character == "boyGhost"):
		$CanvasLayer3/AnimationPlayer/boy.visible = false
	$CanvasLayer/TileMap.visible=true
	$CanvasModulate.color = Color(0.0, 0.994, 0.816)
	$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.323, 0.28)
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	if (Global.character == "girlGhost"):
		$CanvasLayer3/AnimationPlayer/girl.visible = true
	if (Global.character == "boyGhost"):
		$CanvasLayer3/AnimationPlayer/boy.visible = true
	$CanvasLayer/TileMap.visible=false
	$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
	$CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$AudioStreamPlayer.play()
	$CanvasLayer3/AnimationPlayer2.play("phone")
	$CanvasLayer3/AnimationPlayer2/Phone.visible=true
	await $AudioStreamPlayer.finished
	$CanvasLayer3/AnimationPlayer2/Phone.visible=false
	await start_dialogue(1)
	if (Global.character == "girlGhost"):
		$CanvasLayer3/AnimationPlayer.play("girlExit")
		await $CanvasLayer3/AnimationPlayer.animation_finished
	if (Global.character == "boyGhost"):
		$CanvasLayer3/AnimationPlayer.play("boyExit")
		await $CanvasLayer3/AnimationPlayer.animation_finished
	await start_dialogue(2)
	$CanvasLayer3/ghosttalk2/skip.visible=false
	$CanvasLayer3/Node3/ColorRect.visible=true
	$CanvasLayer3/Node3/Menucard.visible=true
	$CanvasLayer3/Node3/Label2.visible=true
	$CanvasLayer3/Node3/Label.visible=true
	$CanvasLayer3/Node3/Label3.visible=true
	$CanvasLayer3/Node3/continue.visible=true
	$CanvasLayer3/Node3/continue/CollisionShape2D.disabled=false
	$CanvasLayer3/Node3/continue.pressed.connect(_on_button_pressed)
	$CanvasLayer3/PresentTile.challengecompleted.connect(afterpuzzle)
	$CanvasLayer3/comb.combpress.connect(combpress)
	
func _process(_delta):
	var timer = $CanvasLayer3/Node3/Timer2
	
	if not timer.is_stopped():
		var time_left = timer.time_left
		var total_time = timer.wait_time
		
		var t = time_left / total_time
		
		if time_left < 11.0:
			if int(Time.get_ticks_msec() / 300) % 3 == 0:
				$CanvasLayer3/Node3/Label5.add_theme_color_override("font_color", Color(1,0,0))
			else:
				$CanvasLayer3/Node3/Label5.add_theme_color_override("font_color", Color(0,0,0))
		
		# start slow (0.75) → end normal (1.0)
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
		$CanvasLayer3/bedroomfailghost/Label.visible=false
		$CanvasLayer3/bedroomfailghost/GirlGhost.visible=false
		$CanvasLayer3/bedroomfailghost/BoyGhost.visible=false
		$CanvasLayer3/bedroomfailghost/skip.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girltext"

		elif Global.character =="boyGhost":
			anim_name ="boytext"
		else:
			print("error animating text")
	
	if anim_index == 1:
		$CanvasLayer3/bedroomfailghost/Label.visible=false
		$CanvasLayer3/bedroomfailghost/GirlGhost.visible=false
		$CanvasLayer3/bedroomfailghost/BoyGhost.visible=false
		$CanvasLayer3/bedroomfailghost/skip.visible=false
			
		$CanvasLayer3/ghosttalk/skip.visible=false
		$CanvasLayer3/ghosttalk/Label.visible=false
		$CanvasLayer3/ghosttalk/BoyGhost.visible=false
		$CanvasLayer3/ghosttalk/GirlGhost.visible=false
		if Global.character =="girlGhost":
#basically hide stuff from prev anim that didn’t finish, like last segment here
			anim_name = "friendcallgirl"

		elif Global.character =="boyGhost":
			anim_name ="friendcallboy"
		else:
			print("error animating text")
			
	if anim_index == 2:
		$CanvasLayer3/bedroomfailghost/Label.visible=false
		$CanvasLayer3/bedroomfailghost/GirlGhost.visible=false
		$CanvasLayer3/bedroomfailghost/BoyGhost.visible=false
		$CanvasLayer3/bedroomfailghost/skip.visible=false
			
		$CanvasLayer3/ghosttalk/skip.visible=false
		$CanvasLayer3/ghosttalk/Label.visible=false
		$CanvasLayer3/ghosttalk/BoyGhost.visible=false
		$CanvasLayer3/ghosttalk/GirlGhost.visible=false
		$"CanvasLayer3/friendphone/Friend label".visible=false
		$CanvasLayer3/friendphone/Label4.visible=false
		$CanvasLayer3/friendphone/skip.visible=false
		$CanvasLayer3/friendphone/Friend2.visible=false
		$CanvasLayer3/friendphone/Girl2.visible=false
		$CanvasLayer3/friendphone/YNlabel.visible=false
		$CanvasLayer3/friendphone/Friend.visible=false
		$CanvasLayer3/friendphone/Boy2.visible=false
		if Global.character =="girlGhost":
			anim_name = "girltext2"

		elif Global.character =="boyGhost":
			anim_name ="boytext2"
		else:
			print("error animating text")
			
	if anim_index == 3:
		$CanvasLayer3/bedroomfailghost/Label.visible=false
		$CanvasLayer3/bedroomfailghost/GirlGhost.visible=false
		$CanvasLayer3/bedroomfailghost/BoyGhost.visible=false
		$CanvasLayer3/bedroomfailghost/skip.visible=false
		
		$CanvasLayer3/ghosttalk/skip.visible=false
		$CanvasLayer3/ghosttalk/Label.visible=false
		$CanvasLayer3/ghosttalk/BoyGhost.visible=false
		$CanvasLayer3/ghosttalk/GirlGhost.visible=false
		$"CanvasLayer3/friendphone/Friend label".visible=false
		$CanvasLayer3/friendphone/Label4.visible=false
		$CanvasLayer3/friendphone/skip.visible=false
		$CanvasLayer3/friendphone/Friend2.visible=false
		$CanvasLayer3/friendphone/Girl2.visible=false
		$CanvasLayer3/friendphone/YNlabel.visible=false
		$CanvasLayer3/friendphone/Friend.visible=false
		$CanvasLayer3/friendphone/Boy2.visible=false
		
		$CanvasLayer3/ghosttalk2/Label5.visible=false
		$CanvasLayer3/ghosttalk2/BoyGhost.visible=false
		$CanvasLayer3/ghosttalk2/GirlGhost.visible=false
		$CanvasLayer3/ghosttalk2/GirlGhost2.visible=false
		$CanvasLayer3/ghosttalk2/skip.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girlghost"

		elif Global.character =="boyGhost":
			anim_name ="boyghost"
		else:
			print("error animating text")
	if anim_index == 4:
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
		$CanvasLayer3/ghosttalk/skip.visible=false
		$CanvasLayer3/ghosttalk/Label.visible=false
		$CanvasLayer3/ghosttalk/BoyGhost.visible=false
		$CanvasLayer3/ghosttalk/GirlGhost.visible=false
		
			
	if anim_index ==1:
		$"CanvasLayer3/friendphone/Friend label".visible=false
		$CanvasLayer3/friendphone/Label4.visible=false
		$CanvasLayer3/friendphone/skip.visible=false
		$CanvasLayer3/friendphone/Friend2.visible=false
		$CanvasLayer3/friendphone/Girl2.visible=false
		$CanvasLayer3/friendphone/YNlabel.visible=false
		$CanvasLayer3/friendphone/Friend.visible=false
		$CanvasLayer3/friendphone/Boy2.visible=false
	
	if anim_index == 2:
		$CanvasLayer3/ghosttalk2/Label5.visible=false
		$CanvasLayer3/ghosttalk2/BoyGhost.visible=false
		$CanvasLayer3/ghosttalk2/GirlGhost.visible=false
		$CanvasLayer3/ghosttalk2/GirlGhost2.visible=false
		$CanvasLayer3/ghosttalk2/skip.visible=false
	
	if anim_index ==3: 
		$CanvasLayer3/ghosttalk3/skip.visible=false
		$CanvasLayer3/ghosttalk3/Label3.visible=false
		$CanvasLayer3/ghosttalk3/GirlGhost.visible=false
		$CanvasLayer3/ghosttalk3/BoyGhost.visible=false
		$CanvasLayer3/ghosttalk3/GirlGhost2.visible=false
		$CanvasLayer3/ghosttalk3/BoyGhost2.visible=false
	
	if anim_index ==4 :
		$CanvasLayer3/bedroomfailghost/Label.visible=false
		$CanvasLayer3/bedroomfailghost/GirlGhost.visible=false
		$CanvasLayer3/bedroomfailghost/BoyGhost.visible=false
		$CanvasLayer3/bedroomfailghost/skip.visible=false
			
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


func friendCall():
	if Global.character=="girlGhost":
		$CanvasLayer3/friendphone.play("friendcallgirl")
		await $CanvasLayer3/friendphone.animation_finished
	if Global.character=="boyGhost":
		$CanvasLayer3/friendphone.play("friendcallboy")
		await $CanvasLayer3/friendphone.animation_finished
		
func _on_button_pressed():
	MusicManager.play_scene_music("puzzle2")
	MusicManager.music_player.pitch_scale = 0.75
	print("Signal received in main script!")
	$CanvasLayer3/presenttile.visible=true
	$CanvasLayer3/pasttile.visible=true
	$CanvasLayer3/Node3/ColorRect.visible=true
	$CanvasLayer3/Timer.visible=true
	$"CanvasLayer3/Past Tiles".visible=true
	$"CanvasLayer3/Present Tiles".visible=true
	$CanvasLayer3/Node3/Label5.visible=true
	enable_show_tilecollision()
	$CanvasLayer3/Label4.visible=true

func enable_show_tilecollision():
	$CanvasLayer3/Node3/Timer2.start()
	$CanvasLayer3/PresentTile/tile1.visible=true
	$CanvasLayer3/PresentTile/tile1/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile2.visible=true
	$CanvasLayer3/PresentTile/tile2/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile3.visible=true
	$CanvasLayer3/PresentTile/tile3/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile4.visible=true
	$CanvasLayer3/PresentTile/tile4/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile5.visible=true
	$CanvasLayer3/PresentTile/tile5/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile6.visible=true
	$CanvasLayer3/PresentTile/tile6/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile7.visible=true
	$CanvasLayer3/PresentTile/tile7/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile8.visible=true
	$CanvasLayer3/PresentTile/tile8/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile9.visible=true
	$CanvasLayer3/PresentTile/tile9/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile10.visible=true
	$CanvasLayer3/PresentTile/tile10/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile11.visible=true
	$CanvasLayer3/PresentTile/tile11/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile12.visible=true
	$CanvasLayer3/PresentTile/tile12/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile13.visible=true
	$CanvasLayer3/PresentTile/tile13/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile14.visible=true
	$CanvasLayer3/PresentTile/tile14/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile15.visible=true
	$CanvasLayer3/PresentTile/tile15/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile16.visible=true
	$CanvasLayer3/PresentTile/tile16/CollisionShape2D.disabled=false


func afterpuzzle():
	MusicManager.music_player.pitch_scale = 1.0
	MusicManager.play_scene_music("menu")
	
	$CanvasLayer3/PresentTile/tile1/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile2/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile3/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile4/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile5/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile6/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile7/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile8/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile9/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile10/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile11/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile12/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile13/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile14/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile15/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile16/CollisionShape2D.disabled=true
	$CanvasLayer3/pasttile.visible=true
	$CanvasLayer3/Node3/ColorRect.visible=true
	$CanvasLayer3/presenttile.visible=true
	$CanvasLayer3/Node3/Correct.visible=true
	$CanvasLayer3/Node3/ColorRect.visible=true
	$CanvasLayer3/comb/Comb.visible=true
	$CanvasLayer3/Node3/Label5.visible=true
	$CanvasLayer3/Label4.visible=false
	await get_tree().create_timer(2).timeout
	$CanvasLayer3/Heart.visible=false
	$CanvasLayer3/Heart2.visible=false
	$CanvasLayer3/Heart3.visible=false
	$CanvasLayer3/Heart4.visible=false
	$CanvasLayer3/Heart5.visible=false
	$CanvasLayer3/Heart6.visible=false
	$CanvasLayer3/PresentTile/tile16.visible=false
	$CanvasLayer3/PresentTile/tile15.visible=false
	$CanvasLayer3/PresentTile/tile14.visible=false
	$CanvasLayer3/PresentTile/tile13.visible=false
	$CanvasLayer3/PresentTile/tile12.visible=false
	$CanvasLayer3/PresentTile/tile11.visible=false
	$CanvasLayer3/PresentTile/tile10.visible=false
	$CanvasLayer3/PresentTile/tile9.visible=false
	$CanvasLayer3/PresentTile/tile8.visible=false
	$CanvasLayer3/PresentTile/tile7.visible=false
	$CanvasLayer3/PresentTile/tile6.visible=false
	$CanvasLayer3/PresentTile/tile5.visible=false
	$CanvasLayer3/PresentTile/tile4.visible=false
	$CanvasLayer3/PresentTile/tile3.visible=false
	$CanvasLayer3/PresentTile/tile2.visible=false
	$CanvasLayer3/PresentTile/tile1.visible=false
	$CanvasLayer3/diarycontinue/CollisionShape2D.disabled=false
	$CanvasLayer3/diarycontinue.visible=true
	$CanvasLayer/TileMap.visible=false
	$CanvasLayer3/Node3/Timer.visible=false
	$"CanvasLayer3/Past Tiles".visible=false
	$"CanvasLayer3/Present Tiles".visible=false
	$CanvasLayer3/pasttile.visible=false
	$CanvasLayer3/Node3/ColorRect.visible=false
	$CanvasLayer3/presenttile.visible=false
	$CanvasLayer3/Node3/Correct.visible=false
	$CanvasLayer3/Node3/Label5.visible=false
	$CanvasLayer3/Node3/ColorRect.visible=false
	$CanvasLayer3/comb/Comb.visible=true
	$CanvasLayer3/Node3/Label5.visible=false
	$CanvasLayer3/comb.visible=true
	$CanvasLayer3/Label4.visible=false
	$CanvasLayer3/ColorRect3.visible=true
	$CanvasLayer3/Diarypage.visible=true
	$CanvasLayer3/Label2.visible=true
	$CanvasLayer3/Label.visible=true
	$CanvasLayer3/Label3.visible=true

func diarypagecontinue():
	$CanvasLayer3/diarycontinue/CollisionShape2D.disabled=true
	$CanvasLayer3/diarycontinue.visible=false
	$CanvasLayer3/ColorRect3.visible=false
	$CanvasLayer3/Diarypage.visible=false
	$CanvasLayer3/Label2.visible=false
	$CanvasLayer3/Label.visible=false
	$CanvasLayer3/Label3.visible=false
	$CanvasLayer3/comb/CollisionShape2D.disabled=false
	$CanvasLayer3/Label6.visible=true
	modulatebackghost()

func combpress():
	$CanvasLayer3/Label6.visible=false
	$CanvasLayer3/TileMap3.visible=true
	$CanvasLayer3/comb.visible=false
	$CanvasLayer3/Comb2.visible=true
	$CanvasLayer3/comb/CollisionShape2D.disabled=true
	$CanvasLayer3/blobGhostPlayer.position.x=1800
	await start_dialogue(3)
	$CanvasLayer3/TileMap3.visible=false
	$CanvasLayer3/comb.visible=true
	$CanvasLayer3/Comb2.visible=false
	$CanvasLayer3/Label7.visible=true
		
func modulatebackghost():
	$CanvasLayer/TileMap.visible=false
	$CanvasLayer3/Camera2D.shake(2, 1.4)
	$CanvasModulate.color = Color(0.0, 0.994, 0.816)
	$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.323, 0.28)
	$CanvasLayer4/CanvasModulate2.color= Color(0.094, 0.323, 0.28)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
	$CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasModulate.color = Color(0.0, 0.994, 0.816)
	$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.323, 0.28)
	$CanvasLayer4/CanvasModulate2.color= Color(0.094, 0.323, 0.28)
	$Area2D/CollisionShape2D.disabled=false
