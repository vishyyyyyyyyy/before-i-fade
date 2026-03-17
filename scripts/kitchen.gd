extends Node2D

@onready var narration_label: Label = $ghostlayer/explorelabel
@onready var explore_node: Node = $explore
var clicked_objects := {} 
var time_left_seconds

var segment_data := [
	{ "starts": [0.0], "ends": [3.0] }, #ghost enter
	{ "starts": [0.0, 4.0, 8.0, 12.0], "ends": [2.0, 6.0, 10.0, 14.0] }, #aunt past talk
	{ "starts": [0.0, 6.0, 10.0], "ends": [3.0, 8.0, 13.0] }, #ghost think ab aunt
	{ "starts": [0.0, 4.0], "ends": [2.0, 6.0] }, #fridge
	{ "starts": [0.0, 4.0, 8.0], "ends": [2.0, 6.0, 10.0] }, #b4 challenge
	{ "starts": [0.0, 4.0, 8.0, 12.0], "ends": [2.0, 6.0, 10.0, 14.0] }, #after challenge
	{ "starts": [0.0], "ends": [2.0] }, #fail puzzle
	
]
@onready var anim_players := [
	$ghostlayer/ghosttext1,
	$ghostlayer/aunttext,
	$ghostlayer/ghosttext2,
	$ghostlayer/AnimationPlayer2, #fridge
	$CanvasLayer4/Node3/ghosttext, #b4 challenge
	$CanvasLayer4/Node3/ghosttext2, #after challenge
	$ghostlayer/kitchenfailghost #fail puzzle
	
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

var repeat_lines = [
	'"I feel like I\'ve been here before..."',
	'"This place feels familiar."',
	'"Didn\'t I just do this?"',
	'"Why am I back here again?"',
	'"I swear I was just here."',
	'"Something isn\'t right..."'
]

@onready var furniture = [
				$CanvasModulate/TileMap2, 
				#$CanvasModulate/TileMap,
				$CanvasModulate/TileMap2, 
				$CanvasModulate/Counter,
				$CanvasModulate/Counter2,
				$CanvasModulate/Counter4,
				$CanvasModulate/Counter3,
				$CanvasModulate/Fridge,
				$CanvasModulate/Oven,
				$CanvasModulate/Sink,
				$ghostlayer/Island,
				$ghostlayer/Stool,
				$ghostlayer/Stool2
				]
@onready var doors = [$CanvasModulate/Door2, $CanvasModulate/Door]

@onready var reset_timer = $Timer

func toggle_pause():
	$CanvasPause/PauseMenu/resume/Label.text = "Game Paused"
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	$CanvasPause/ColorRect2.visible=true
	$CanvasPause/Menucard2.visible=true


func fade_out_music():
	var tween = create_tween()
	tween.tween_property(MusicManager.music_player, "volume_db", -40, 5.0)

func fade_in_music():
	var tween = create_tween()
	tween.tween_property(MusicManager.music_player, "volume_db", 0, 8.0)

func _ready() -> void:
	reset_timer.timeout.connect(_on_reset_timeout)
	for item in furniture:
		#print(item)
		item.modulate = Color(0.0, 0.992, 0.816)
	for item in doors:
		#print(item)
		item.modulate= Color(0.094, 0.323, 0.28) 
	#Global.kitchenfail = true
	$CanvasLayer4/ColorRect2.visible=false
	if Global.kitchenfail == true:
		$ghostlayer/kitchenfailghost/Label.text  = repeat_lines.pick_random()
		$CanvasLayer2/failpuzzlecutscene/AnimationPlayer.play("text")
		fade_out_music()
		await get_tree().create_timer(16).timeout
		MusicManager.music_player.pitch_scale = 1.0
		MusicManager.play_scene_music("menu")
		fade_in_music()
		await start_dialogue(6)
	else:
		MusicManager.music_player.pitch_scale = 1.0
		MusicManager.play_scene_music("menu")
		
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"

	Global.bathroomCount = 0
	Global.reusabledesk=3
	Global.reusablehallway=2
	Global.kitchen =2
	Global.livingroom =0
	
	$CanvasLayer4/Node3/diarycontinue.diarypagecontinue.connect(diarypagecontinue)
	$ghostlayer/AnimationPlayer/girl.visible = false
	$ghostlayer/AnimationPlayer/aunt.visible = false
	$ghostlayer/AnimationPlayer/girlSide.visible = false
	$ghostlayer/AnimationPlayer/boy.visible = false
	$ghostlayer/AnimationPlayer/boySide.visible = false
	$CanvasLayer4/ColorRect3.visible=false
	$CanvasLayer4/ColorRect2.visible=false
	$ghostlayer/scenetrigger/CollisionShape2D.disabled=false
	$CanvasLayer4/Node3/continue.pressed.connect(on_button_pressed)
	$CanvasLayer4/foodchoice.challengecompleted.connect(challengecompleted)
	#unlock_explore()
	start()
	
func _process(delta: float) -> void:
	time_left_seconds = $CanvasLayer4/Node3/Timer2.time_left
	$CanvasLayer4/Node3/Label5.text = "%.1f" % time_left_seconds
	
	if time_left_seconds < 11.0:
			if int(Time.get_ticks_msec() / 300) % 3 == 0:
				$CanvasLayer4/Node3/Label5.add_theme_color_override("font_color", Color(1,0,0))
			else:
				$CanvasLayer4/Node3/Label5.add_theme_color_override("font_color", Color(0,0,0))
				
	
	# --- music speed control ---
	if not $CanvasLayer4/Node3/Timer2.is_stopped():
		var total_time = $CanvasLayer4/Node3/Timer2.wait_time
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
		$ghostlayer/kitchenfailghost/Label.visible=false
		$ghostlayer/kitchenfailghost/GirlGhost.visible=false
		$ghostlayer/kitchenfailghost/BoyGhost.visible=false
		$ghostlayer/kitchenfailghost/skip.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	
	if anim_index == 1:
		$ghostlayer/kitchenfailghost/Label.visible=false
		$ghostlayer/kitchenfailghost/GirlGhost.visible=false
		$ghostlayer/kitchenfailghost/BoyGhost.visible=false
		$ghostlayer/kitchenfailghost/skip.visible=false
		
		$ghostlayer/ghosttext1/GirlGhost.visible=false
		$ghostlayer/ghosttext1/BoyGhost.visible=false
		$ghostlayer/ghosttext1/Label.visible=false
		$ghostlayer/ghosttext1/skip.visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	
	if anim_index == 2:
		$ghostlayer/kitchenfailghost/Label.visible=false
		$ghostlayer/kitchenfailghost/GirlGhost.visible=false
		$ghostlayer/kitchenfailghost/BoyGhost.visible=false
		$ghostlayer/kitchenfailghost/skip.visible=false
		
		$ghostlayer/aunttext/aunt2.visible=false
		$ghostlayer/ghosttext1/GirlGhost.visible=false
		$ghostlayer/ghosttext1/BoyGhost.visible=false
		$ghostlayer/ghosttext1/Label.visible=false
		$ghostlayer/ghosttext1/skip.visible=false
		$"ghostlayer/aunttext/Aunt label".visible=false
		$ghostlayer/aunttext/aunt.visible=false
		$ghostlayer/aunttext/Label4.visible=false
		$ghostlayer/aunttext/Boy1.visible=false
		$ghostlayer/aunttext/Boy2.visible=false
		$ghostlayer/aunttext/Boy3.visible=false
		$"ghostlayer/aunttext/YN label".visible=false
		$ghostlayer/aunttext/Girl2.visible=false
		$ghostlayer/aunttext/Girl3.visible=false
		$ghostlayer/aunttext/Girl.visible=false
		$ghostlayer/aunttext/skip.visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	
	if anim_index == 3:
		$ghostlayer/kitchenfailghost/Label.visible=false
		$ghostlayer/kitchenfailghost/GirlGhost.visible=false
		$ghostlayer/kitchenfailghost/BoyGhost.visible=false
		$ghostlayer/kitchenfailghost/skip.visible=false
		
		$ghostlayer/ghosttext2/Label3.visible=false
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		$ghostlayer/aunttext/aunt2.visible=false
		$ghostlayer/ghosttext1/GirlGhost.visible=false
		$ghostlayer/ghosttext1/BoyGhost.visible=false
		$ghostlayer/ghosttext1/Label.visible=false
		$ghostlayer/ghosttext1/skip.visible=false
		$"ghostlayer/aunttext/Aunt label".visible=false
		$ghostlayer/aunttext/aunt.visible=false
		$ghostlayer/aunttext/Label4.visible=false
		$ghostlayer/aunttext/Boy1.visible=false
		$ghostlayer/aunttext/Boy2.visible=false
		$ghostlayer/aunttext/Boy3.visible=false
		$"ghostlayer/aunttext/YN label".visible=false
		$ghostlayer/aunttext/Girl2.visible=false
		$ghostlayer/aunttext/Girl3.visible=false
		$ghostlayer/aunttext/Girl.visible=false
		$ghostlayer/aunttext/skip.visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
		
		
	if anim_index == 4:
		$ghostlayer/kitchenfailghost/Label.visible=false
		$ghostlayer/kitchenfailghost/GirlGhost.visible=false
		$ghostlayer/kitchenfailghost/BoyGhost.visible=false
		$ghostlayer/kitchenfailghost/skip.visible=false
		
		$ghostlayer/AnimationPlayer2/Label2.visible=false
		$ghostlayer/AnimationPlayer2/GirlGhost.visible=false
		$ghostlayer/AnimationPlayer2/BoyGhost.visible=false
		$ghostlayer/AnimationPlayer2/skip.visible=false
		
		$ghostlayer/ghosttext2/Label3.visible=false
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		$ghostlayer/aunttext/aunt2.visible=false
		$ghostlayer/ghosttext1/GirlGhost.visible=false
		$ghostlayer/ghosttext1/BoyGhost.visible=false
		$ghostlayer/ghosttext1/Label.visible=false
		$ghostlayer/ghosttext1/skip.visible=false
		$"ghostlayer/aunttext/Aunt label".visible=false
		$ghostlayer/aunttext/aunt.visible=false
		$ghostlayer/aunttext/Label4.visible=false
		$ghostlayer/aunttext/Boy1.visible=false
		$ghostlayer/aunttext/Boy2.visible=false
		$ghostlayer/aunttext/Boy3.visible=false
		$"ghostlayer/aunttext/YN label".visible=false
		$ghostlayer/aunttext/Girl2.visible=false
		$ghostlayer/aunttext/Girl3.visible=false
		$ghostlayer/aunttext/Girl.visible=false
		$ghostlayer/aunttext/skip.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
			
	if anim_index ==5:
		$ghostlayer/kitchenfailghost/Label.visible=false
		$ghostlayer/kitchenfailghost/GirlGhost.visible=false
		$ghostlayer/kitchenfailghost/BoyGhost.visible=false
		$ghostlayer/kitchenfailghost/skip.visible=false
		
		
		$CanvasLayer4/Node3/ghosttext/Label3.visible=false
		$CanvasLayer4/Node3/ghosttext/GirlGhost.visible=false
		$CanvasLayer4/Node3/ghosttext/BoyGhost.visible=false
		$CanvasLayer4/Node3/ghosttext/skip.visible=false
		
		$ghostlayer/AnimationPlayer2/Label2.visible=false
		$ghostlayer/AnimationPlayer2/GirlGhost.visible=false
		$ghostlayer/AnimationPlayer2/BoyGhost.visible=false
		$ghostlayer/AnimationPlayer2/skip.visible=false
		
		$ghostlayer/ghosttext2/Label3.visible=false
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/skip.visible=false
		$ghostlayer/aunttext/aunt2.visible=false
		$ghostlayer/ghosttext1/GirlGhost.visible=false
		$ghostlayer/ghosttext1/BoyGhost.visible=false
		$ghostlayer/ghosttext1/Label.visible=false
		$ghostlayer/ghosttext1/skip.visible=false
		$"ghostlayer/aunttext/Aunt label".visible=false
		$ghostlayer/aunttext/aunt.visible=false
		$ghostlayer/aunttext/Label4.visible=false
		$ghostlayer/aunttext/Boy1.visible=false
		$ghostlayer/aunttext/Boy2.visible=false
		$ghostlayer/aunttext/Boy3.visible=false
		$"ghostlayer/aunttext/YN label".visible=false
		$ghostlayer/aunttext/Girl2.visible=false
		$ghostlayer/aunttext/Girl3.visible=false
		$ghostlayer/aunttext/Girl.visible=false
		$ghostlayer/aunttext/skip.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	
	if anim_index == 6: 
		if Global.character =="girlGhost":
			anim_name = "repeatgirl"

		elif Global.character =="boyGhost":
			anim_name ="repeatboy"
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
		$ghostlayer/ghosttext1/GirlGhost.visible=false
		$ghostlayer/ghosttext1/BoyGhost.visible=false
		$ghostlayer/ghosttext1/Label.visible=false
		$ghostlayer/ghosttext1/skip.visible=false
			
	if anim_index == 1:
		$"ghostlayer/aunttext/Aunt label".visible=false
		$ghostlayer/aunttext/aunt.visible=false
		$ghostlayer/aunttext/aunt2.visible=false
		$ghostlayer/aunttext/Label4.visible=false
		$ghostlayer/aunttext/Boy1.visible=false
		$ghostlayer/aunttext/Boy2.visible=false
		$ghostlayer/aunttext/Boy3.visible=false
		$"ghostlayer/aunttext/YN label".visible=false
		$ghostlayer/aunttext/Girl2.visible=false
		$ghostlayer/aunttext/Girl3.visible=false
		$ghostlayer/aunttext/Girl.visible=false
		$ghostlayer/aunttext/skip.visible=false
		
	if anim_index == 2:
		$ghostlayer/ghosttext2/Label3.visible=false
		$ghostlayer/ghosttext2/GirlGhost.visible=false
		$ghostlayer/ghosttext2/BoyGhost.visible=false
		$ghostlayer/ghosttext2/skip.visible=false

	if anim_index == 3:
		$ghostlayer/AnimationPlayer2/Label2.visible=false
		$ghostlayer/AnimationPlayer2/GirlGhost.visible=false
		$ghostlayer/AnimationPlayer2/BoyGhost.visible=false
		$ghostlayer/AnimationPlayer2/skip.visible=false
		
	if anim_index ==4:
		$CanvasLayer4/Node3/ghosttext/Label3.visible=false
		$CanvasLayer4/Node3/ghosttext/GirlGhost.visible=false
		$CanvasLayer4/Node3/ghosttext/BoyGhost.visible=false
		$CanvasLayer4/Node3/ghosttext/skip.visible=false
		
	if anim_index ==5:
		$CanvasLayer4/Node3/ghosttext2/Label4.visible=false
		$CanvasLayer4/Node3/ghosttext2/GirlGhost.visible=false
		$CanvasLayer4/Node3/ghosttext2/BoyGhost.visible=false
		$CanvasLayer4/Node3/ghosttext2/GirlGhost2.visible=false
		$CanvasLayer4/Node3/ghosttext2/skip.visible=false
		$CanvasLayer4/Node3/ghosttext2/BoyGhost2.visible=false
		
	if anim_index ==6:
		$ghostlayer/kitchenfailghost/Label.visible=false
		$ghostlayer/kitchenfailghost/GirlGhost.visible=false
		$ghostlayer/kitchenfailghost/BoyGhost.visible=false
		$ghostlayer/kitchenfailghost/skip.visible=false
		
		
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


func start():
	if Global.character == "boyGhost":
		await start_dialogue(0)
		await get_tree().create_timer(0.5).timeout
		await kitchenmodulate()
		$ghostlayer/AnimationPlayer/boy.visible = false
		$ghostlayer/AnimationPlayer/aunt.visible = true
		$ghostlayer/AnimationPlayer/boySide.visible = true
		await start_dialogue(1)
		$ghostlayer/AnimationPlayer/boy.visible = true
		$ghostlayer/AnimationPlayer/aunt.visible = false
		$ghostlayer/AnimationPlayer/boySide.visible = false
		await start_dialogue(2)
		unlock_explore()
		
	if Global.character == "girlGhost":
		await start_dialogue(0)
		await get_tree().create_timer(0.5).timeout
		await kitchenmodulate()
		$ghostlayer/AnimationPlayer/girl.visible = false
		$ghostlayer/AnimationPlayer/aunt.visible = true
		$ghostlayer/AnimationPlayer/girlSide.visible = true
		await start_dialogue(1)
		$ghostlayer/AnimationPlayer/girl.visible = true
		$ghostlayer/AnimationPlayer/aunt.visible = false
		$ghostlayer/AnimationPlayer/girlSide.visible = false
		await start_dialogue(2)
		unlock_explore()
		
func kitchenmodulate():
	$ghostlayer/Camera2D.shake(2, 1.4)
	if (Global.character == "girlGhost"):
		$ghostlayer/AnimationPlayer/girl.visible = true
	if (Global.character == "boyGhost"):
		$ghostlayer/AnimationPlayer/boy.visible = true
	for item in furniture:
		item.modulate = Color(1, 1, 1, 1)
	for item in doors:
		item.modulate= Color(1, 1, 1, 1)
	await get_tree().create_timer(0.5).timeout
	if (Global.character == "girlGhost"):
		$ghostlayer/AnimationPlayer/girl.visible = false
	if (Global.character == "boyGhost"):
		$ghostlayer/AnimationPlayer/boy.visible = false
	for item in furniture:
		item.modulate = Color(0.0, 0.994, 0.816)
	for item in doors:
		item.modulate= Color(0.094, 0.322, 0.278)
	await get_tree().create_timer(0.5).timeout
	if (Global.character == "girlGhost"):
		$ghostlayer/AnimationPlayer/girl.visible = true
	if (Global.character == "boyGhost"):
		$ghostlayer/AnimationPlayer/boy.visible = true
	for item in furniture:
		item.modulate = Color(1, 1, 1, 1)
	for item in doors:
		item.modulate= Color(1, 1, 1, 1)
	await get_tree().create_timer(0.5).timeout

func _on_reset_timeout():
	narration_label.text = "Interact with objects around the kitchen to investigate."

func unlock_explore():
	$explore/cabinet/CollisionShape2D.disabled=false
	$explore/cabinet/CollisionShape2D2.disabled=false
	$explore/cabinet/CollisionShape2D3.disabled=false
	$explore/cabinet/CollisionShape2D4.disabled=false
	$explore/oven/CollisionShape2D.disabled=false
	$explore/cabinet/CollisionShape2D.disabled=false
	$explore/sink/CollisionShape2D.disabled=false
	$explore/fridge/CollisionShape2D.disabled=false
	$explore/chair/CollisionShape2D.disabled=false
	$explore/island/CollisionShape2D.disabled=false
	$explore/chair/CollisionShape2D2.disabled=false
	
	$ghostlayer/explorelabel.visible=true
	
	var areas = {
		"cabinet": $explore/cabinet,
		"oven": $explore/oven,
		"fridge": $explore/fridge,
		"chair": $explore/chair,
		"sink": $explore/sink,
		"island": $explore/island
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
	# Immediately update the label for any object
	narration_label.text = text
	narration_label.visible = true

	# Mark this object as clicked
	if not clicked_objects.has(area_name):
		clicked_objects[area_name] = true


	if area_name == "island" and not all_non_photos_clicked():
		narration_label.text = "Let's finish looking at everything else first."
		narration_label.visible = true
		reset_timer.start() 
		return


	if area_name == "fridge":
		$ghostlayer/TileMap3.visible = true
		$ghostlayer/Fridge.visible = true
		$ghostlayer/explorelabel.visible = false
		$explore/cabinet/CollisionShape2D.disabled = false
		$explore/cabinet/CollisionShape2D2.disabled = true
		$explore/cabinet/CollisionShape2D3.disabled = true
		$explore/cabinet/CollisionShape2D4.disabled = true
		$explore/oven/CollisionShape2D.disabled = true
		$explore/sink/CollisionShape2D.disabled = true
		$explore/fridge/CollisionShape2D.disabled = true
		$explore/chair/CollisionShape2D.disabled = true
		$explore/chair/CollisionShape2D2.disabled = true
		$explore/island/CollisionShape2D.disabled = true

		await start_dialogue(3)

		$ghostlayer/explorelabel.visible = true
		$ghostlayer/TileMap3.visible = false
		$ghostlayer/Fridge.visible = false
		$explore/cabinet/CollisionShape2D.disabled = false
		$explore/cabinet/CollisionShape2D2.disabled = false
		$explore/cabinet/CollisionShape2D3.disabled = false
		$explore/cabinet/CollisionShape2D4.disabled = false
		$explore/oven/CollisionShape2D.disabled = false
		$explore/sink/CollisionShape2D.disabled = false
		$explore/fridge/CollisionShape2D.disabled = false
		$explore/chair/CollisionShape2D.disabled = false
		$explore/chair/CollisionShape2D2.disabled = false
		$explore/island/CollisionShape2D.disabled = false

		narration_label.text = "Interact with objects around the kitchen to investigate."
		return

	if area_name == "island" and all_non_photos_clicked():
		$explore/cabinet/CollisionShape2D.disabled = true
		$explore/cabinet/CollisionShape2D2.disabled = true
		$explore/cabinet/CollisionShape2D3.disabled = true
		$explore/cabinet/CollisionShape2D4.disabled = true
		$explore/oven/CollisionShape2D.disabled = true
		$explore/sink/CollisionShape2D.disabled = true
		$explore/fridge/CollisionShape2D.disabled = true
		$explore/chair/CollisionShape2D.disabled = true
		$explore/island/CollisionShape2D.disabled = true
		$explore/chair/CollisionShape2D2.disabled = true
		$ghostlayer/explorelabel.visible = false
		$CanvasLayer4/ColorRect2.visible = true
		$CanvasLayer4/Kitchen.visible = true

		await start_dialogue(4)

		$CanvasLayer4/Node3/ColorRect.visible = true
		$CanvasLayer4/Node3/Menucard.visible = true
		$CanvasLayer4/Node3/Label2.visible = true
		$CanvasLayer4/Node3/Label.visible = true
		$CanvasLayer4/Node3/Label3.visible = true
		$CanvasLayer4/Node3/continue/CollisionShape2D.disabled = false
		$CanvasLayer4/Node3/continue.visible = true
		kitchenpuzzle()
		return
		
	reset_timer.start()
	
func all_non_photos_clicked() -> bool:
	var non_desk = ["cabinet", "oven", "sink", "fridge", "chair"]
	for name in non_desk:
		if not clicked_objects.has(name): 
			return false
	return true

func on_button_pressed():
	MusicManager.play_scene_music("puzzle2")
	MusicManager.music_player.pitch_scale = 0.75
	$CanvasLayer4/Node3/Heart.visible=true
	$CanvasLayer4/Node3/Heart2.visible=true
	$CanvasLayer4/Node3/Heart3.visible=true
	$ghostlayer/explorelabel.visible=false
	$CanvasLayer4/Node3/Timer.visible=true
	$CanvasLayer4/Node3/Label5.visible=true
	$CanvasLayer4/Node3/Label6.visible=true
	$CanvasLayer4/Node3/Timer2.start()
	$CanvasLayer4/ColorRect3.visible=true
	$CanvasLayer4/foodchoice/CollisionShape2D.disabled=false
	$CanvasLayer4/foodchoice/CollisionShape2D2.disabled=false
	$CanvasLayer4/foodchoice/CollisionShape2D3.disabled=false
	$CanvasLayer4/Flour.visible=true
	$CanvasLayer4/Radish.visible=true
	$CanvasLayer4/Strawberry.visible=true
	
func kitchenpuzzle():
	$CanvasLayer4/ColorRect2.visible=true
	$CanvasLayer4/ColorRect3.visible=true
	$CanvasLayer4/ColorRect3.visible=true
	$CanvasLayer4/Node3/Label6.visible=true
	$CanvasLayer4/Label.visible=true
	$CanvasLayer4/foodchoice.visible=true
	$CanvasLayer4/Node3/ColorRect.visible=true
	$CanvasLayer4/Node3/Menucard.visible=true
	$CanvasLayer4/Node3/Label2.visible=true
	$CanvasLayer4/Node3/Label.visible=true
	$CanvasLayer4/Node3/Label3.visible=true
	$CanvasLayer4/Node3/continue/CollisionShape2D.disabled=false
	$CanvasLayer4/Node3/continue.visible=true
	$CanvasLayer4/Kitchen.visible=true
	$CanvasLayer4/foodchoice/CollisionShape2D4.disabled=true
	
func challengecompleted():
	MusicManager.music_player.pitch_scale = 1.0
	MusicManager.play_scene_music("menu")
	$CanvasLayer4/Node3/Label6.visible=false
	await get_tree().create_timer(2).timeout
	$CanvasLayer4/ColorRect3.visible=false
	$CanvasLayer4/Label.visible=false
	$CanvasLayer4/Node3/Diarypage.visible=true
	$CanvasLayer4/Node3/ColorRect.visible=true
	$CanvasLayer4/Node3/Diarypage.visible=true
	$CanvasLayer4/Node3/Label4.visible=true
	$CanvasLayer4/Node3/Label7.visible=true
	$CanvasLayer4/Node3/Label8.visible=true
	$ghostlayer/blobGhostPlayer.position.x=1153
	$CanvasLayer4/Node3/diarycontinue.visible=true
	$CanvasLayer4/Node3/diarycontinue/CollisionShape2D.disabled=false
	
func diarypagecontinue():
	$CanvasLayer4/Node3/diarycontinue.visible=false
	$CanvasLayer4/Node3/diarycontinue/CollisionShape2D.disabled=true
	$CanvasLayer4/Node3/Diarypage.visible=false
	$CanvasLayer4/Node3/ColorRect.visible=false
	$CanvasLayer4/Node3/Diarypage.visible=false
	$CanvasLayer4/Node3/Label4.visible=false
	$CanvasLayer4/Node3/Label7.visible=false
	$CanvasLayer4/Node3/Label8.visible=false
	$CanvasLayer4/Kitchen9.visible=false
	$CanvasLayer4/Kitchen.visible=false
	$CanvasLayer4/Node3/Label5.visible=false
	$CanvasLayer4/Node3/Timer.visible=false
	#$CanvasLayer4/Node3/Label11.visible=false
	$ghostlayer/Camera2D.shake(2, 1.4)
	for item in furniture:
		item.modulate = Color(0.0, 0.992, 0.816)
	for item in doors:
		item.modulate= Color(0.094, 0.323, 0.28) 
	if (Global.character == "girlGhost"):
		$ghostlayer/AnimationPlayer/girl.visible = false
	if (Global.character == "boyGhost"):
		$ghostlayer/AnimationPlayer/boy.visible = false
	await get_tree().create_timer(0.5).timeout
	for item in furniture:
		item.modulate = Color(1,1,1,1)
	for item in doors:
		item.modulate= Color(1,1,1,1) 
	if (Global.character == "girlGhost"):
		$ghostlayer/AnimationPlayer/girl.visible = true
	if (Global.character == "boyGhost"):
		$ghostlayer/AnimationPlayer/boy.visible = true
	await get_tree().create_timer(0.5).timeout
	for item in furniture:
		item.modulate = Color(0.0, 0.992, 0.816)
	for item in doors:
		item.modulate= Color(0.094, 0.323, 0.28) 
	if (Global.character == "girlGhost"):
		$ghostlayer/AnimationPlayer/girl.visible = false
	if (Global.character == "boyGhost"):
		$ghostlayer/AnimationPlayer/boy.visible = false
	await get_tree().create_timer(0.5).timeout 
	$CanvasLayer4/Kitchen20.visible=true
	$CanvasLayer4/ColorRect2.visible=true
	await start_dialogue(5)
	$CanvasLayer4/Kitchen20.visible=false
	$CanvasLayer4/ColorRect2.visible=false
	$CanvasLayer4/Node3/Label11.visible=true
	$ghostlayer/scenetrigger/CollisionShape2D.disabled=false
	$ghostlayer/Node2D/arrow.play("arrow")
	
	print("bathroom count: " + str(Global.bathroomCount))
	print("reusabledesk count: " + str(Global.reusabledesk))
	print("reusablehallway count: " + str(Global.reusablehallway))
	print("kitchen: " + str(Global.kitchen))
	print("livingroom: " + str(Global.livingroom))


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
