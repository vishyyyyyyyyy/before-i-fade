extends Node2D

var time_left_seconds

var segment_data := [
	{ "starts": [0.0, 4.0], "ends": [2.0, 6.0] }, 	
]
@onready var anim_players := [
	$ghostlayer/ghosttext
]
var anim_index := 0
var anim: AnimationPlayer
var dialogue_active := false
var segment_index := 0
var animating := true
var segment_starts
var segment_ends
	
signal dialogue_finished(index)

func _process(_delta):
	time_left_seconds = $ghostlayer/Timer2.time_left
	$ghostlayer/Label5.text = "%.1f" % time_left_seconds
	
	# --- music speed control ---
	if not $ghostlayer/Timer2.is_stopped():
		var total_time = $ghostlayer/Timer2.wait_time
		var t = time_left_seconds / total_time
		
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
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
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

func _ready() -> void:
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
	MusicManager.music_player.pitch_scale = 1.0
	MusicManager.play_scene_music("menu")
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
		get_tree().change_scene_to_file("res://scenes/endcreds.tscn")

func on_button_pressed():
	MusicManager.music_player.pitch_scale = 0.75
	MusicManager.play_scene_music("puzzle2")
	$ghostlayer/Label5.visible=true
	$ghostlayer/Timer.visible=true
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
	$CanvasLayer3/Camera2D.shake(2, 1.4)
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

	
	
