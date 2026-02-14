extends Node2D


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
	
]
@onready var anim_players := [
	$ghostlayer/ghosttext1,
	$ghostlayer/extext,
	$ghostlayer/ghosttext2,
	$ghostlayer/ghosttext3,
	$ghostlayer/ghosttext4
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
	$ghostlayer/scentrigger/CollisionShape2D.disabled=false
	$CanvasLayer/AnimationPlayer/boy.visible = false
	$CanvasLayer/AnimationPlayer/girl.visible = false
	$CanvasLayer/AnimationPlayer/boySide.visible = false
	$CanvasLayer/AnimationPlayer/girlSide.visible = false
	$CanvasLayer/AnimationPlayer/boyDown.visible = false
	$CanvasLayer/AnimationPlayer/girlDown.visible = false
	$CanvasLayer3/CanvasModulate/Tv.visible=true
	$CanvasLayer/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	$CanvasLayer4/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer3/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	$ghostlayer/diarycontinue.diarypagecontinue.connect(diarypagecontinue)
	$ghostlayer/pianokeys.challengecompleted.connect(challengecompleted)
	$ghostlayer/continue.pressed.connect(pressed)
	await start_dialogue(0)
	await modulatelivingroom()
	
func _process(delta: float) -> void:
	time_left_seconds = $ghostlayer/Timer2.time_left
	$ghostlayer/Label8.text = "%.1f" % time_left_seconds
	
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
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer3/CanvasModulate.color =Color(1,1,1,1)
	$CanvasLayer/AnimationPlayer/boy.visible = true
	$CanvasLayer/AnimationPlayer/girl.visible = true
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	$CanvasLayer4/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer3/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	$CanvasLayer/AnimationPlayer/boy.visible = false
	$CanvasLayer/AnimationPlayer/girl.visible = false
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer3/CanvasModulate.color =Color(1,1,1,1)
	$CanvasLayer/AnimationPlayer/boy.visible = true
	$CanvasLayer/AnimationPlayer/girl.visible = true
	await start_dialogue(1)
	$CanvasLayer/AnimationPlayer.play("exit")
	await $CanvasLayer/AnimationPlayer.animation_finished
	await start_dialogue(2)
	$ghostlayer/explorelabel.visible=true
	unlockexplore()

func unlockexplore():
	$ghostlayer/explorelabel.visible=true
	$explore/CanvasLayer/bookshelf/CollisionShape2D.disabled=false
	$explore/CanvasLayer/clock/CollisionShape2D.disabled=false
	$explore/CanvasLayer/couch/CollisionShape2D.disabled=false
	$explore/CanvasLayer/table/CollisionShape2D.disabled=false
	$explore/CanvasLayer/tv/CollisionShape2D.disabled=false
	$explore/CanvasLayer/rug/CollisionShape2D.disabled=false
	$explore/CanvasLayer/flower/CollisionShape2D.disabled=false
	$explore/CanvasLayer/piano/CollisionShape2D.disabled=false
	
	var areas = {
		"bookshelf": $explore/CanvasLayer/bookshelf,
		"clock": $explore/CanvasLayer/clock,
		"couch": $explore/CanvasLayer/couch,
		"table": $explore/CanvasLayer/table,
		"tv": $explore/CanvasLayer/tv,
		"rug": $explore/CanvasLayer/rug,
		"flower": $explore/CanvasLayer/flower,
		"piano": $explore/CanvasLayer/piano,
		
	}
	for name in areas.keys():
			var area_node = areas[name]
			if area_node is Area2D:
				area_node.clicked.connect(func(text):
					_on_object_clicked(text, name)
			)
func _on_object_clicked(text: String, area_name: String):
	# If desk clicked before finishing others
	if area_name == "piano" and not all_non_photos_clicked():
		narration_label.text = "Let's finish looking at everything else first."
		narration_label.visible = true
		return
# Mark this area as clicked
	clicked_objects[area_name] = true

	# Update label
	narration_label.text = text
	narration_label.visible = true
	
	if area_name == "piano" and all_non_photos_clicked():
		print("yes")
		challenge()
	
		
func all_non_photos_clicked() -> bool:
	var non_desk = ["bookshelf", "clock", "table", "couch", "tv", "flower", "rug"]
	for name in non_desk:
		if not clicked_objects.has(name): 
			return false
	return true

func challenge():
	$ghostlayer/explorelabel.visible=false
	$CanvasLayer3/CanvasModulate/Tv.visible=false
	$explore/CanvasLayer/bookshelf/CollisionShape2D.disabled=true
	$explore/CanvasLayer/clock/CollisionShape2D.disabled=true
	$explore/CanvasLayer/couch/CollisionShape2D.disabled=true
	$explore/CanvasLayer/table/CollisionShape2D.disabled=true
	$explore/CanvasLayer/tv/CollisionShape2D.disabled=true
	$explore/CanvasLayer/rug/CollisionShape2D.disabled=true
	$explore/CanvasLayer/flower/CollisionShape2D.disabled=true
	$explore/CanvasLayer/piano/CollisionShape2D.disabled=true
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
	$ghostlayer/Label.visible=false
	$ghostlayer/Label2.visible=false
	$ghostlayer/Label3.visible=false
	$ghostlayer/Label4.visible=false
	$ghostlayer/Label9.visible=false
	$explore/CanvasLayer/bookshelf/CollisionShape2D.disabled=true
	$explore/CanvasLayer/clock/CollisionShape2D.disabled=true
	$explore/CanvasLayer/couch/CollisionShape2D.disabled=true
	$explore/CanvasLayer/table/CollisionShape2D.disabled=true
	$explore/CanvasLayer/tv/CollisionShape2D.disabled=true
	$explore/CanvasLayer/rug/CollisionShape2D.disabled=true
	$explore/CanvasLayer/flower/CollisionShape2D.disabled=true
	$explore/CanvasLayer/piano/CollisionShape2D.disabled=true
	$ghostlayer/pianokeys/CollisionShape2D6/ColorRect.visible=false
	$ghostlayer/Correct.visible=false
	$ghostlayer/ColorRect.visible=true
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
	$ghostlayer/blobGhostPlayer.position.x = 2128
	$ghostlayer/blobGhostPlayer.position.y = 399
	await start_dialogue(4)
	$CanvasLayer3/CanvasModulate/Tv.visible=true
	$ghostlayer/blobGhostPlayer.position.x = 2128
	$ghostlayer/blobGhostPlayer.position.y = 399
	$ghostlayer/Music.visible=false
	$ghostlayer/Music2.visible=false
	$ghostlayer/Music3.visible=false
	$CanvasLayer/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	$CanvasLayer4/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer3/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer3/CanvasModulate.color =Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	$CanvasLayer4/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer3/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	$ghostlayer/scentrigger/CollisionShape2D.disabled=false
	$ghostlayer/Label14.visible=true
	
