extends Node2D

@onready var name_input: LineEdit = $LineEdit

var code = ""
var count = 0
var time_left_seconds
var music_start_time = 0.0

var hearts = 3



var segment_data := [
	{ "starts": [0.0, 4.0], "ends": [2.0, 6.0] }, #puzzle instructions
	{ "starts": [0.0, 4.0, 8.0, 13.0], "ends": [2.0, 6.0, 11.0, 15.0] },  #open diary
	{ "starts": [0.0, 6.0, 10.0], "ends": [2.0, 8.0, 12.0] }, #read diary entry
]
@onready var anim_players := [
	$AnimationPlayer,
	$AnimationPlayer2,
	$AnimationPlayer3
]
var anim_index := 0
var anim: AnimationPlayer
var dialogue_active := false
var segment_index := 0
var animating := true
var segment_starts
var segment_ends

signal dialogue_finished(index)


func _ready():
	MusicManager.music_player.pitch_scale = 1.0
	$Node3/Label2.visible=true
	$Node3/Label.visible=true
	$Node3/Label3.visible=true
	$Node3/Menucard.visible=true
	$Node3/ColorRect.visible=true
	$Node3/continue.visible=true
	$TextureRect/TextureButton.disabled=true
	$TextureRect/TextureButton2.disabled=true
	$TextureRect/TextureButton3.disabled=true
	$TextureRect/TextureButton4.disabled=true
	$TextureRect/TextureButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$TextureRect/TextureButton2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$TextureRect/TextureButton3.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$TextureRect/TextureButton4.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Node3/continue.pressed.connect(_on_continue_pressed)
	name_input.text_submitted.connect(_on_name_submitted)
	$diarycontinue.diarypagecontinue.connect(diarypagecontinue)


var diary_started := false

func _input(event):
	if not dialogue_active or diary_started:
		return
	if event.is_action_pressed("ui_accept") and diary_started:
		diary_started = false
		play_diary_sequence()
	
	if event.is_action_pressed("ui_accept") and not event.is_echo():
		textskip()

func end_dialogue():
	dialogue_active = false
	anim.stop()

	print("Dialogue finished:", anim_index)
	if anim_index == 0:
		$desk/CollisionShape2D.disabled=false
		$AnimationPlayer/Label3.visible=true
		$AnimationPlayer/skip.visible=false
		$AnimationPlayer/Bedss.visible=false
		$AnimationPlayer/Label4.visible=false
		$Timer.visible=true
		if hearts == 3:
			$Heart.visible=true
			$Heart2.visible=true
			$Heart3.visible=true
		if hearts == 2:
			$Heart.visible=true
			$Heart2.visible=true
		if hearts == 1:
			$Heart.visible=true
		$Label2.visible=true
		$Timer2.start()
		

	if anim_index ==1:
		pass
		
	if anim_index ==2:
		$AnimationPlayer/skip.visible=false
		$AnimationPlayer2/skip.visible=false
		$AnimationPlayer3/skip.visible=false
		$AnimationPlayer/Bedss.visible=false
		$AnimationPlayer/Label4.visible=false
		

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


func _on_name_submitted(text: String):
	print("Player name:", text)
	Global.charName = text

	diary_started = false
	play_diary_sequence()

func _on_continue_pressed():
	MusicManager.play_scene_music("puzzle2")
	MusicManager.music_player.pitch_scale = 0.75
	music_start_time = Time.get_ticks_msec() / 1000.0
	#MusicManager.music_player.pitch_scale = 0.75
	print("Node was clicked!")
	await start_dialogue(0)
	$CanvasModulate/blobGhostPlayer.position.x =506.0 
	$CanvasModulate/blobGhostPlayer.position.y =533 #1912.0 orignal, 535.0
	$Timer2.start()
	$desk/CollisionShape2D.disabled=true
	$Label2.visible=true
	$Timer.visible=true
	$desk/CollisionShape2D.disabled=false
	$Node3/continue/CollisionShape2D.disabled=true
	$desk.clicked.connect(_on_desk_clicked)
	
	
func _on_desk_clicked():
	print("Clicked from main script!")
	$TextureRect/TextureButton.disabled=false
	$TextureRect/TextureButton2.disabled=false
	$TextureRect/TextureButton3.disabled=false
	$TextureRect/TextureButton4.disabled=false
	$TextureRect/TextureButton.mouse_filter = Control.MOUSE_FILTER_STOP
	$TextureRect/TextureButton2.mouse_filter = Control.MOUSE_FILTER_STOP
	$TextureRect/TextureButton3.mouse_filter = Control.MOUSE_FILTER_STOP
	$TextureRect/TextureButton4.mouse_filter = Control.MOUSE_FILTER_STOP


func _process(delta: float) -> void:
	#if $Timer2.is_stopped and !_on_continue_pressed():
		#MusicManager.music_player.pitch_scale = 0.75

	time_left_seconds = $Timer2.time_left
	$Label2.text = "%.1f" % time_left_seconds
	$Label2.add_theme_color_override("font_color", Color(0,0,0))
	
	var total_time = $Timer2.wait_time
	var t = time_left_seconds / total_time 
	#var elapsed = (Time.get_ticks_msec() / 1000.0) - music_start_time
	#var duration = $Timer2.wait_time
	 
	if time_left_seconds < 11.0 and !$Timer2.is_stopped():
		MusicManager.music_player.pitch_scale = lerp(1.0, 0.75, t)
		if int(Time.get_ticks_msec() / 300) % 3 == 0:
			$Label2.add_theme_color_override("font_color", Color(1,0,0))
		else:
			$Label2.add_theme_color_override("font_color", Color(0,0,0))

	
	if not dialogue_active or not animating:
		return
		
	
	if anim.current_animation == "":
		return # No animation playing, skip

	if anim.get_current_animation_position() >= segment_ends[segment_index]:
		anim.pause()
		animating = false
	
	#if $AnimationPlayer/Label3.visible:
		#$Node/Bedss.visible = false
	#elif $AnimationPlayer/Label.visible:
		#$Node/Bedss.visible = true


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
		anim_name = "text"
	
	if anim_index == 1:
		print("2nd anim6")
		$AnimationPlayer/skip.visible=false
		$AnimationPlayer/Label3.visible=false
		$AnimationPlayer/Label.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girlnametext"

		elif Global.character =="boyGhost":
			anim_name ="boynametext"
		else:
			print("error animating text")
			
	if anim_index == 2:
		$AnimationPlayer/skip.visible=false
		$AnimationPlayer2/skip.visible=false
		$AnimationPlayer/Label3.visible=false
		$AnimationPlayer/Label.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girldiaryentry1"

		elif Global.character =="boyGhost":
			anim_name ="boydiaryentry1"
		else:
			print("error animating text")
			
	anim.play(anim_name) 
	   
	await dialogue_finished 


func _on_texture_button_pressed() -> void:
	$CanvasLayer4/CanvasModulate.color =  Color(0.442, 0.429, 0.419)
	$CanvasLayer2/CanvasModulate.color =  Color(1, 1, 1)
	$CanvasLayer3/CanvasModulate.color =  Color(1, 1, 1)
	$CanvasLayer/CanvasModulate.color =  Color(1, 1, 1)
	code = code + "P"
	count += 1
	check_code()


func _on_texture_button_2_pressed() -> void:
	$CanvasLayer2/CanvasModulate.color = Color(0.442, 0.429, 0.419)
	$CanvasLayer/CanvasModulate.color =  Color(1, 1, 1)
	$CanvasLayer3/CanvasModulate.color =  Color(1, 1, 1)
	$CanvasLayer4/CanvasModulate.color =  Color(1, 1, 1)
	code = code + "y"
	count += 1
	check_code()

func _on_texture_button_3_pressed() -> void:
	$CanvasLayer3/CanvasModulate.color = Color(0.442, 0.429, 0.419)
	$CanvasLayer4/CanvasModulate.color =  Color(1, 1, 1)
	$CanvasLayer/CanvasModulate.color =  Color(1, 1, 1)
	$CanvasLayer2/CanvasModulate.color =  Color(1, 1, 1)
	code = code + "g"
	count += 1
	check_code()

func _on_texture_button_4_pressed() -> void:
	$CanvasLayer/CanvasModulate.color = Color(0.442, 0.429, 0.419)
	$CanvasLayer4/CanvasModulate.color =  Color(1, 1, 1)
	$CanvasLayer3/CanvasModulate.color =  Color(1, 1, 1)
	$CanvasLayer2/CanvasModulate.color =  Color(1, 1, 1)
	code = code + 'p'
	count += 1
	check_code()
			

func _on_timer_2_timeout():
	$Timer2.stop()
	$TextureRect/TextureButton.disabled= true
	$TextureRect/TextureButton2.disabled= true
	$TextureRect/TextureButton3.disabled= true
	$TextureRect/TextureButton4.disabled= true
	$CanvasLayer5/Wrong.visible = true
	$AudioStreamPlayer2.play()
	
	MusicManager.music_player.pitch_scale = 1.0
	hearts -= 1
	if hearts  ==2:
		$Heart3.visible=false
		$Heart6.visible=true
		
	elif hearts  ==1:
		$Heart2.visible=false
		$Heart5.visible=true

	elif hearts <= 0:
		$Heart.visible=false
		$Heart4.visible=true
		Global.bedroomfail = true
		$Timer2.stop() 
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://scenes/bedroom2.tscn")
		return
	
	else:
		return
		
	await get_tree().create_timer(2).timeout
	$CanvasLayer5/Wrong.visible = false
	$"Deskcloseup2".visible=false
	$"CanvasLayer".visible = false
	$"CanvasLayer2".visible = false
	$"CanvasLayer3".visible = false
	$"CanvasLayer4".visible = false
	$CanvasLayer/CanvasModulate.color = Color(1, 1, 1, 1)
	$CanvasLayer2/CanvasModulate.color = Color(1, 1, 1, 1)
	$CanvasLayer3/CanvasModulate.color = Color(1, 1, 1, 1)
	$CanvasLayer4/CanvasModulate.color = Color(1, 1, 1, 1)
	$Label2.add_theme_color_override("font_color", Color(0,0,0))
	reset_puzzle()
	
func check_code():
	if count == 4:
		
		if code == "ypPg":
			MusicManager.play_scene_music("menu")
			$Timer2.stop() 
			$AudioStreamPlayer.play()
			$CanvasLayer5/Correct.visible = true
			$TextureRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$TextureRect.visible=false
			$TextureRect/TextureButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$TextureRect/TextureButton2.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$TextureRect/TextureButton3.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$TextureRect/TextureButton4.mouse_filter = Control.MOUSE_FILTER_IGNORE
			await get_tree().create_timer(2).timeout
			$CanvasLayer5/Correct.visible = false
			$AnimationPlayer/Label.visible=false
			$AnimationPlayer/Label3.visible=false
			correct()
		else:
			$CanvasLayer5/Wrong.visible = true
			$AudioStreamPlayer2.play()
			await get_tree().create_timer(2).timeout
			$CanvasLayer5/Correct.visible = false
			wrong()
			

func reset_puzzle():
	code = ""
	count = 0
	$desk/CollisionShape2D.disabled=true
	$CanvasLayer5/Wrong.visible = false
	$AnimationPlayer/Label3.visible=false
	$CanvasLayer5/Correct.visible = false
	$CanvasLayer3.visible=false
	$CanvasLayer2.visible=false
	$CanvasLayer4.visible=false
	$CanvasLayer.visible=false
	
	$"Deskcloseup2".visible=false
	$"CanvasLayer".visible = false
	$"CanvasLayer2".visible = false
	$"CanvasLayer3".visible = false
	$"CanvasLayer4".visible = false
	$CanvasLayer/CanvasModulate.color = Color(1, 1, 1, 1)
	$CanvasLayer2/CanvasModulate.color = Color(1, 1, 1, 1)
	$CanvasLayer3/CanvasModulate.color = Color(1, 1, 1, 1)
	$CanvasLayer4/CanvasModulate.color = Color(1, 1, 1, 1)
	await start_dialogue(0)
	
func wrong():
	$TextureRect/TextureButton.disabled= true
	$TextureRect/TextureButton2.disabled= true
	$TextureRect/TextureButton3.disabled= true
	$TextureRect/TextureButton4.disabled= true
	
	code = ""
	count = 0
	$CanvasLayer5/Wrong.visible = true
	$CanvasLayer5/Correct.visible = false
	
	hearts -= 1
	if hearts  ==2:
		$Heart3.visible=false
		$Heart6.visible=true
		
	elif hearts  ==1:
		$Heart2.visible=false
		$Heart5.visible=true

	elif hearts <= 0:
		$Heart.visible=false
		$Heart4.visible=true
		$Timer2.stop() 
		await get_tree().create_timer(1).timeout
		Global.bedroomfail = true
		get_tree().change_scene_to_file("res://scenes/bedroom2.tscn")
		return
	
	else:
		return
		
	
	await get_tree().create_timer(2).timeout
	$CanvasLayer5/Wrong.visible = false
	$"Deskcloseup2".visible=false
	$"CanvasLayer".visible = false
	$"CanvasLayer2".visible = false
	$"CanvasLayer3".visible = false
	$"CanvasLayer4".visible = false
	$CanvasLayer/CanvasModulate.color = Color(1, 1, 1, 1)
	$CanvasLayer2/CanvasModulate.color = Color(1, 1, 1, 1)
	$CanvasLayer3/CanvasModulate.color = Color(1, 1, 1, 1)
	$CanvasLayer4/CanvasModulate.color = Color(1, 1, 1, 1)
	reset_puzzle()
	
func correct():
	$CanvasLayer4.visible=false
	$CanvasLayer3.visible=false
	$CanvasLayer2.visible=false
	$CanvasLayer.visible=false
	$Node4/ColorRect3.visible=true
	$Node4/Diarypage.visible=true
	$Node4/Label2.visible=true
	$Node4/Label.visible=true
	$Node4/Label3.visible=true
	$Label2.visible=false
	$Timer.visible=false
	$diarycontinue.visible=true
	$diarycontinue/CollisionShape2D.disabled=false

func diarypagecontinue():
	$diarycontinue.visible=false
	$diarycontinue/CollisionShape2D.disabled=true
	$"CanvasLayer".visible = false
	$"CanvasLayer2".visible = false
	$"CanvasLayer3".visible = false
	$"CanvasLayer4".visible = false
	$CanvasLayer5/Correct.visible = false
	$Node4/ColorRect3.visible=false
	$Node4/Diarypage.visible=false
	$Node4/Label2.visible=false
	$Node4/Label.visible=false
	$Node4/Label3.visible=false
	$Desk2.visible=true
	if Global.character == "girlGhost":
		await start_dialogue(1)
		$AnimationPlayer2/Label6.visible=true
		diary_started=true
		$LineEdit.editable=true
		$LineEdit.visible=true
		
	if Global.character == "boyGhost":
		await start_dialogue(1)
		$AnimationPlayer2/Label6.visible=true
		diary_started=true
		$LineEdit.editable=true
		$LineEdit.visible=true
	
func play_diary_sequence():
	print("playing diary sequence?")
	$AnimationPlayer2/Label6.visible=false
	$desk/CollisionShape2D.disabled=true
	if Global.character == "girlGhost":
		$LineEdit.editable=false
		$LineEdit.visible=false
		$Diaryentry1.visible=true
		$Deskcloseup2.visible=false
		await start_dialogue(2)
		$Desk2.visible=false
		await get_tree().create_timer(2).timeout
		$AnimationPlayer3/Label4.visible=false
		$AnimationPlayer3/GirlGhost.visible=false
		$AnimationPlayer3/BoyGhost.visible=false
		$AnimationPlayer2/GirlGhost.visible=false
		$AnimationPlayer2/BoyGhost.visible=false
		$Diaryentry1.visible=false
		$CanvasModulate/Calendar2.visible=true
		$AnimationPlayer3/skip.visible=false
		$Camera2D.shake(2, 1.4)
		$CanvasModulate.color = Color(0.0, 0.994, 0.816)
		await get_tree().create_timer(0.5).timeout
		$CanvasModulate.color = Color(1,1,1,1)
		$CanvasModulate/Calendar2.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasModulate/Calendar2.visible=true
		$CanvasModulate.color = Color(0.0, 0.994, 0.816)
		$SceneTrigger/CollisionShape2D.disabled=false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer6/Label6.visible=true
		
	if Global.character == "boyGhost":
		$AnimationPlayer2/Label6.visible=false
		$LineEdit.editable=false
		$LineEdit.visible=false
		$Diaryentry1.visible=true
		$Deskcloseup2.visible=false
		await start_dialogue(2)
		$Desk2.visible=false
		await get_tree().create_timer(2).timeout
		$AnimationPlayer3/Label4.visible=false
		$AnimationPlayer3/GirlGhost.visible=false
		$AnimationPlayer3/BoyGhost.visible=false
		$AnimationPlayer2/GirlGhost.visible=false
		$AnimationPlayer2/BoyGhost.visible=false
		$Diaryentry1.visible=false
		$CanvasModulate/Calendar2.visible=true
		$AnimationPlayer3/skip.visible=false
		$Camera2D.shake(2, 1.4)
		$CanvasModulate.color = Color(0.0, 0.994, 0.816)
		await get_tree().create_timer(0.5).timeout
		$CanvasModulate.color = Color(1,1,1,1)
		$CanvasModulate/Calendar2.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasModulate/Calendar2.visible=true
		$CanvasModulate.color = Color(0.0, 0.994, 0.816)
		$SceneTrigger/CollisionShape2D.disabled=false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer6/Label6.visible=true
