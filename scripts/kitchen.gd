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
	{ "starts": [0.0, 4.0, 8.0, 12.0], "ends": [2.0, 6.0, 10.0, 14.0] } #after challenge
	
]
@onready var anim_players := [
	$ghostlayer/ghosttext1,
	$ghostlayer/aunttext,
	$ghostlayer/ghosttext2,
	$CanvasLayer2/CanvasModulate/AnimationPlayer, #fridge
	$CanvasLayer4/Node3/ghosttext, #b4 challenge
	$CanvasLayer4/Node3/ghosttext2 #after challenge
]
var anim_index := 0
var anim: AnimationPlayer
var dialogue_active := false
var segment_index := 0
var animating := true
var segment_starts
var segment_ends
	
signal dialogue_finished(index)



func _ready() -> void:
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
	$CanvasLayer/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer2/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer3/CanvasModulate.modulate = Color(0.094, 0.323, 0.28) 
	start()
	
func _process(delta: float) -> void:
	time_left_seconds = $CanvasLayer4/Node3/Timer2.time_left
	$CanvasLayer4/Node3/Label5.text = "%.1f" % time_left_seconds
	
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
		
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	
	if anim_index == 1:
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
		$CanvasLayer2/CanvasModulate/AnimationPlayer/Label2.visible=false
		$CanvasLayer2/CanvasModulate/AnimationPlayer/GirlGhost.visible=false
		$CanvasLayer2/CanvasModulate/AnimationPlayer/BoyGhost.visible=false
		$CanvasLayer2/CanvasModulate/AnimationPlayer/skip.visible=false
		
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
		
		$CanvasLayer4/Node3/ghosttext/Label3.visible=false
		$CanvasLayer4/Node3/ghosttext/GirlGhost.visible=false
		$CanvasLayer4/Node3/ghosttext/BoyGhost.visible=false
		$CanvasLayer4/Node3/ghosttext/skip.visible=false
		
		$CanvasLayer2/CanvasModulate/AnimationPlayer/Label2.visible=false
		$CanvasLayer2/CanvasModulate/AnimationPlayer/GirlGhost.visible=false
		$CanvasLayer2/CanvasModulate/AnimationPlayer/BoyGhost.visible=false
		$CanvasLayer2/CanvasModulate/AnimationPlayer/skip.visible=false
		
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
		$CanvasLayer2/CanvasModulate/AnimationPlayer/Label2.visible=false
		$CanvasLayer2/CanvasModulate/AnimationPlayer/GirlGhost.visible=false
		$CanvasLayer2/CanvasModulate/AnimationPlayer/BoyGhost.visible=false
		$CanvasLayer2/CanvasModulate/AnimationPlayer/skip.visible=false
		
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
	$CanvasLayer/CanvasModulate.modulate = Color(1,1,1,1)
	$CanvasLayer2/CanvasModulate.modulate = Color(1,1,1,1)
	$CanvasLayer3/CanvasModulate.modulate = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	if (Global.character == "girlGhost"):
		$ghostlayer/AnimationPlayer/girl.visible = false
	if (Global.character == "boyGhost"):
		$ghostlayer/AnimationPlayer/boy.visible = false
	$CanvasLayer/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer2/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer3/CanvasModulate.modulate = Color(0.094, 0.323, 0.28) 
	await get_tree().create_timer(0.5).timeout
	if (Global.character == "girlGhost"):
		$ghostlayer/AnimationPlayer/girl.visible = true
	if (Global.character == "boyGhost"):
		$ghostlayer/AnimationPlayer/boy.visible = true
	$CanvasLayer/CanvasModulate.modulate = Color(1,1,1,1)
	$CanvasLayer2/CanvasModulate.modulate = Color(1,1,1,1)
	$CanvasLayer3/CanvasModulate.modulate = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout


func unlock_explore():
	$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=false
	$explore/CanvasLayer/cabinet/CollisionShape2D2.disabled=false
	$explore/CanvasLayer/cabinet/CollisionShape2D3.disabled=false
	$explore/CanvasLayer/cabinet/CollisionShape2D4.disabled=false
	$explore/CanvasLayer/oven/CollisionShape2D.disabled=false
	$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=false
	$explore/CanvasLayer/sink/CollisionShape2D.disabled=false
	$explore/CanvasLayer/fridge/CollisionShape2D.disabled=false
	$explore/CanvasLayer/chair/CollisionShape2D.disabled=false
	$explore/CanvasLayer/island/CollisionShape2D.disabled=false
	$explore/CanvasLayer/chair/CollisionShape2D2.disabled=false
	
	$ghostlayer/explorelabel.visible=true
	
	var areas = {
		"cabinet": $explore/CanvasLayer/cabinet,
		"oven": $explore/CanvasLayer/oven,
		"fridge": $explore/CanvasLayer/fridge,
		"chair": $explore/CanvasLayer/chair,
		"sink": $explore/CanvasLayer/sink,
		"island": $explore/CanvasLayer/island
	}
	for name in areas:
		var area_node = areas[name]

		if area_node is Area2D:
			area_node.clicked.connect(
				func(text):
					_on_object_clicked(text, name)
			)
func _on_object_clicked(text: String, area_name: String):
	# If desk clicked before finishing others
	if area_name == "island" and not all_non_photos_clicked():
		narration_label.text = "Let's finish looking at everything else first."
		narration_label.visible = true
		return
# Mark this area as clicked
	clicked_objects[area_name] = true

	# Update label
	narration_label.text = text
	narration_label.visible = true
	
	if area_name == "fridge":
		$CanvasLayer2/CanvasModulate/TileMap3.visible=true
		$CanvasLayer2/CanvasModulate/Fridge.visible=true
		$ghostlayer/explorelabel.visible=false
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=false
		$explore/CanvasLayer/cabinet/CollisionShape2D2.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D3.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D4.disabled=true
		$explore/CanvasLayer/oven/CollisionShape2D.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=true
		$explore/CanvasLayer/sink/CollisionShape2D.disabled=true
		$explore/CanvasLayer/fridge/CollisionShape2D.disabled=true
		$explore/CanvasLayer/chair/CollisionShape2D.disabled=true
		$explore/CanvasLayer/chair/CollisionShape2D2.disabled=true
		$explore/CanvasLayer/island/CollisionShape2D.disabled=true
		await start_dialogue(3)
		$ghostlayer/explorelabel.visible=true
		$CanvasLayer2/CanvasModulate/TileMap3.visible=false
		$CanvasLayer2/CanvasModulate/Fridge.visible=false
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=false
		$explore/CanvasLayer/cabinet/CollisionShape2D2.disabled=false
		$explore/CanvasLayer/cabinet/CollisionShape2D3.disabled=false
		$explore/CanvasLayer/cabinet/CollisionShape2D4.disabled=false
		$explore/CanvasLayer/oven/CollisionShape2D.disabled=false
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=false
		$explore/CanvasLayer/sink/CollisionShape2D.disabled=false
		$explore/CanvasLayer/fridge/CollisionShape2D.disabled=false
		$explore/CanvasLayer/chair/CollisionShape2D.disabled=false
		$explore/CanvasLayer/island/CollisionShape2D.disabled=false
		$explore/CanvasLayer/chair/CollisionShape2D2.disabled=false
		$ghostlayer/explorelabel.visible=true
		
		
		
	if area_name == "island" and all_non_photos_clicked():
		print("yes")
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D2.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D3.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D4.disabled=true
		$explore/CanvasLayer/oven/CollisionShape2D.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=true
		$explore/CanvasLayer/sink/CollisionShape2D.disabled=true
		$explore/CanvasLayer/fridge/CollisionShape2D.disabled=true
		$explore/CanvasLayer/chair/CollisionShape2D.disabled=true
		$explore/CanvasLayer/island/CollisionShape2D.disabled=true
		$explore/CanvasLayer/chair/CollisionShape2D2.disabled=true
		$ghostlayer/explorelabel.visible=false
		$CanvasLayer4/ColorRect2.visible=true
		$CanvasLayer4/Kitchen.visible=true
		await start_dialogue(4)
		$CanvasLayer4/Node3/ColorRect.visible=true
		$CanvasLayer4/Node3/Menucard.visible=true
		$CanvasLayer4/Node3/Label2.visible=true
		$CanvasLayer4/Node3/Label.visible=true
		$CanvasLayer4/Node3/Label3.visible=true
		$CanvasLayer4/Node3/continue/CollisionShape2D.disabled=false
		$CanvasLayer4/Node3/continue.visible=true
		kitchenpuzzle()
		
		
func all_non_photos_clicked() -> bool:
	var non_desk = ["cabinet", "oven", "sink", "fridge", "chair"]
	for name in non_desk:
		if not clicked_objects.has(name): 
			return false
	return true

func on_button_pressed():
	MusicManager.play_scene_music("puzzle2")
	MusicManager.music_player.pitch_scale = 0.75
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
	$CanvasLayer/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer2/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer3/CanvasModulate.modulate = Color(0.094, 0.323, 0.28) 
	if (Global.character == "girlGhost"):
		$ghostlayer/AnimationPlayer/girl.visible = false
	if (Global.character == "boyGhost"):
		$ghostlayer/AnimationPlayer/boy.visible = false
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.modulate = Color(1,1,1,1)
	$CanvasLayer2/CanvasModulate.modulate = Color(1,1,1,1)
	$CanvasLayer3/CanvasModulate.modulate = Color(1,1,1,1)
	if (Global.character == "girlGhost"):
		$ghostlayer/AnimationPlayer/girl.visible = true
	if (Global.character == "boyGhost"):
		$ghostlayer/AnimationPlayer/boy.visible = true
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer2/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer3/CanvasModulate.modulate = Color(0.094, 0.323, 0.28)
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
	
	print("bathroom count: " + str(Global.bathroomCount))
	print("reusabledesk count: " + str(Global.reusabledesk))
	print("reusablehallway count: " + str(Global.reusablehallway))
	print("kitchen: " + str(Global.kitchen))
	print("livingroom: " + str(Global.livingroom))
