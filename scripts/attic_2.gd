extends Node2D

var time_left_seconds

var segment_data := [
	{ "starts": [0.0, 4.0], "ends": [2.0, 6.0] },
	{ "starts": [0.0], "ends": [2.0] }, 	
]
@onready var anim_players := [
	$ghostlayer/ghosttext,
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


func _process(_delta):
	time_left_seconds = $ghostlayer/Timer2.time_left
	$ghostlayer/Label5.text = "%.1f" % time_left_seconds
	
	$ghostlayer/Label5.add_theme_color_override("font_color", Color(0,0,0))
	# --- music speed control ---
	if not $ghostlayer/Timer2.is_stopped():
		var total_time = $ghostlayer/Timer2.wait_time
		var t = time_left_seconds / total_time
		
		# start slow (0.75) → end normal (1.0)
		MusicManager.music_player.pitch_scale = lerp(0.75, 0.4, t)
		
	if time_left_seconds < 6:
		if int(Time.get_ticks_msec() / 300) % 3 == 0:
			$ghostlayer/Label5.add_theme_color_override("font_color", Color(1,0,0))
		else:
			$ghostlayer/Label5.add_theme_color_override("font_color", Color(0,0,0))
	
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
		$ghostlayer/ghosttext/skip.visible=false
	
	if anim_index ==1:
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
			
func fade_out_music():
	var tween = create_tween()
	tween.tween_property(MusicManager.music_player, "volume_db", -40, 5.0)

func fade_in_music():
	var tween = create_tween()
	tween.tween_property(MusicManager.music_player, "volume_db", 0, 8.0)


func _ready():
	MusicManager.music_player.pitch_scale = 0.75
	#Global.attic2fail = true
	if Global.attic2fail == true:
		$ghostlayer/bedroomfailghost/Label.text  = repeat_lines.pick_random()
		fade_out_music()
		$ghostlayer/failpuzzlecutscene/AnimationPlayer.play("text")
		await get_tree().create_timer(16).timeout
		await start_dialogue(1)
	else:
		MusicManager.music_player.pitch_scale = 0.75
		MusicManager.play_scene_music("menu")
		
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"
	$ghostlayer/continue.pressed.connect(on_button_pressed)
	$ghostlayer/Area2D.challengecompleted.connect(challengecompleted)
	Global.ending= 2
	$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	$ghostlayer/Bloodblanket.visible=true
	await atticmodulate()
	$ghostlayer/AnimationPlayer2.play("phoneopen")
	await $ghostlayer/AnimationPlayer2.animation_finished
	$ghostlayer/continue/CollisionShape2D.disabled=false
	$ghostlayer/continue.visible=true
	$ghostlayer/Label4.visible=true
	$ghostlayer/Label.visible=true
	$ghostlayer/Label3.visible=true
	$ghostlayer/Menucard.visible=true
	$ghostlayer/ColorRect.visible=true
	
func challengecompleted():
	MusicManager.music_player.pitch_scale = 0.75
	MusicManager.play_scene_music("menu")
	$ghostlayer/Heart.visible=false
	$ghostlayer/Heart2.visible=false
	$ghostlayer/Heart3.visible=false
	$ghostlayer/Heart4.visible=false
	$ghostlayer/Heart5.visible=false
	$ghostlayer/Heart6.visible=false
	$ghostlayer/Timer.visible=false
	$ghostlayer/recphone.visible=true
	$ghostlayer/Label5.visible=false
	
	if Global.character == "girlGhost":
		$ghostlayer/idle/girl.visible=false
		$ghostlayer/chars2girl.play("kill")
		await $ghostlayer/chars2girl.animation_finished
		$ghostlayer/Label2.visible=false
		$ghostlayer/recphone.visible=false
		$ghostlayer/AnimationPlayer.play("end")
		await $ghostlayer/AnimationPlayer.animation_finished
		$ghostlayer/chars2girl/boy.visible=false
		$ghostlayer/chars2girl/girl.visible=false
		$ghostlayer/idle/girl.visible=false
		$ghostlayer/blobGhostPlayer.position.x=1205
		$ghostlayer/blobGhostPlayer.position.y=641
		await start_dialogue(0)
		await get_tree().create_timer(0.3).timeout
		await fade_out_node($ghostlayer/blobGhostPlayer, 2.5)
		$ghostlayer/AnimationPlayer3.play("modulate")
		await $ghostlayer/AnimationPlayer3.animation_finished
		get_tree().change_scene_to_file("res://scenes/endcreds.tscn")
		
	if Global.character == "boyGhost":
		$ghostlayer/idle/boy.visible=false
		$ghostlayer/chars2boy.play("boy")
		await $ghostlayer/chars2boy.animation_finished
		$ghostlayer/Label2.visible=false
		$ghostlayer/recphone.visible=false
		$ghostlayer/AnimationPlayer.play("end")
		await $ghostlayer/AnimationPlayer.animation_finished
		$ghostlayer/chars2boy/boy.visible=false
		$ghostlayer/chars2boy/girl.visible=false
		$ghostlayer/idle/boy.visible=false
		$ghostlayer/recphone.visible=false
		$ghostlayer/blobGhostPlayer.position.x=1205
		$ghostlayer/blobGhostPlayer.position.y=641
		await start_dialogue(0)
		await get_tree().create_timer(0.3).timeout
		await fade_out_node($ghostlayer/blobGhostPlayer, 2.5)
		$ghostlayer/AnimationPlayer3.play("modulate")
		await $ghostlayer/AnimationPlayer3.animation_finished
		get_tree().change_scene_to_file("res://scenes/endcreds.tscn")

func on_button_pressed():
	MusicManager.music_player.pitch_scale = 0.75
	MusicManager.play_scene_music("puzzle2")
	$ghostlayer/Label5.visible=true
	$ghostlayer/Timer.visible=true
	if Global.hardmode: 
		if Global.hearts == 3:
			$ghostlayer/Heart.visible=true
			$ghostlayer/Heart2.visible=true
			$ghostlayer/Heart3.visible=true
		elif Global.hearts == 2:
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
		$ghostlayer/Heart4.visible=false
		$ghostlayer/Heart5.visible=false
		$ghostlayer/Heart6.visible=false
	$ghostlayer/Label4.visible=false
	$ghostlayer/Timer2.start()
	$"ghostlayer/phone instructions".visible=true
	$ghostlayer/AnimationPlayer2/closedphone.visible=false
	$"ghostlayer/AnimationPlayer2/open phone".visible=false
	$ghostlayer/Area2D/CollisionShape2D.disabled= false
	$ghostlayer/Area2D/CollisionShape2D2.disabled=false
	$ghostlayer/Area2D/CollisionShape2D3.disabled= false
	$ghostlayer/Area2D/CollisionShape2D4.disabled= false
	$ghostlayer/Area2D/CollisionShape2D5.disabled= false
	$ghostlayer/Area2D/CollisionShape2D6.disabled = false
	
	
func atticmodulate():
	##past char in modulations
	$ghostlayer/Camera2D.shake(2, 1.4)
	if Global.character =="boyGhost":
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		$ghostlayer/idle/boy.visible=true
		$ghostlayer/Bloodblanket.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
		$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
		$ghostlayer/idle/boy.visible=false
		$ghostlayer/Bloodblanket.visible=true
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		$ghostlayer/Bloodblanket.visible=false
		$ghostlayer/idle/boy.visible=true
		
	if Global.character =="girlGhost":
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		$ghostlayer/idle/girl.visible=true
		$ghostlayer/Bloodblanket.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
		$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
		$ghostlayer/idle/girl.visible=false
		$ghostlayer/Bloodblanket.visible=true
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		$ghostlayer/Bloodblanket.visible=false
		$ghostlayer/idle/girl.visible=true
	
func fade_out_node(node: CanvasItem, duration := 2.0) -> void:
	var elapsed := 0.0

	while elapsed < duration:
		elapsed += get_process_delta_time()
		var t := elapsed / duration
		node.modulate.a = lerp(1.0, 0.0, t)
		await get_tree().process_frame

	node.modulate.a = 0.0
