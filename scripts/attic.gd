extends Node2D

@onready var narration_label: Label = $ghostlayer/explorelabel
@onready var explore_node: Node = $explore
var clicked_objects := {} 
var time_left_seconds

func _ready() -> void:
	presentbox()
	$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	$ghostlayer/Bloodblanket.visible=true
	$ghostlayer/continue.pressed.connect(on_button_pressed)
	$CanvasLayer/CanvasModulate/box2.challengecompleted.connect(challengecompleted)
	$ghostlayer/choice.choice1.connect(choice1)
	$ghostlayer/choice.choice2.connect(choice2)
	text()
	
	
func _process(delta: float) -> void:
	time_left_seconds = $ghostlayer/Timer2.time_left
	$ghostlayer/Label8.text = "%.1f" % time_left_seconds


func text():
	if Global.character == "girlGhost":
		$ghostlayer/ghosttext.play("girl")
	if Global.character == "boyGhost":
		$ghostlayer/ghosttext.play("boy")
	await $ghostlayer/ghosttext.animation_finished
	await atticmodulate()
	if Global.character == "girlGhost":
		$ghostlayer/pastchar1.play("girl")
	if Global.character == "boyGhost":
		$ghostlayer/pastchar1.play("boy")
	await $ghostlayer/pastchar1.animation_finished
	$ghostlayer/idle/girl.visible=false
	$ghostlayer/idle/boy.visible=false
	$ghostlayer/AnimationPlayer.play("death")
	await $ghostlayer/AnimationPlayer.animation_finished
	$ghostlayer/Bloodblanket.visible=true
	if Global.character == "girlGhost":
		$ghostlayer/ghosttext2.play("girl")
	if Global.character == "boyGhost":
		$ghostlayer/ghosttext2.play("boy")
	await $ghostlayer/ghosttext2.animation_finished
	$ghostlayer/explorelabel.visible=true
	unlockexplore()

	
func atticmodulate():
	##past char in modulations
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
	for name in areas.keys():
			var area_node = areas[name]
			if area_node is Area2D:
				area_node.clicked.connect(func(text):
					_on_object_clicked(text, name)
			)
func _on_object_clicked(text: String, area_name: String):
	# If desk clicked before finishing others
	if area_name == "box" and not all_non_photos_clicked():
		narration_label.text = "Let's finish looking at everything else first."
		narration_label.visible = true
		return
# Mark this area as clicked
	clicked_objects[area_name] = true

	# Update label
	narration_label.text = text
	narration_label.visible = true
	
	if area_name == "box" and all_non_photos_clicked():
		print("yes")
		$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
		$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
		presentbox()
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		pastbox()
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
		$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
		presentbox()
		if Global.character == "girlGhost":
			$ghostlayer/ghosttext3.play("girl")
		if Global.character == "boyGhost":
			$ghostlayer/ghosttext3.play("boy")
		await $ghostlayer/ghosttext3.animation_finished
		challenge()
	
		
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
		$ghostlayer/pastchar2.play("girl")
		await $ghostlayer/pastchar2.animation_finished
		$ghostlayer/chars2girl.play("kill")
		$ghostlayer/idle/girl.visible=false
		await $ghostlayer/chars2girl.animation_finished
		$ghostlayer/Bloodblanket.visible=true
			
	if Global.character == "boyGhost":
		$ghostlayer/chars2boy.play("boy")
		await $ghostlayer/chars2boy.animation_finished
		$ghostlayer/pastchar2.play("boy")
		await $ghostlayer/pastchar2.animation_finished
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
	
func _on_timer_2_timeout() -> void:
	print("lose")
	$ghostlayer/Timer2.stop()
	$ghostlayer/Wrong.visible=true
	$ghostlayer/AudioStreamPlayer2.play()
	await get_tree().create_timer(2).timeout
	$ghostlayer/Wrong.visible=false
	resetpuzzle()	
	

func resetpuzzle():
	$ghostlayer/present.visible=false
	$ghostlayer/present2.visible=false
	$CanvasLayer/CanvasModulate/box2/box1/Box2.visible=false
	$CanvasLayer/CanvasModulate/box2/box2/Box2.visible=false
	$CanvasLayer/CanvasModulate/box2/box3/Box2.visible=false
	$CanvasLayer/CanvasModulate/box2/box4/Box2.visible=false
	$CanvasLayer/CanvasModulate/box2/box5/Box2.visible=false
	$CanvasLayer/CanvasModulate/box2/box6/Box2.visible=false
	$CanvasLayer/CanvasModulate/box2/box7/Box2.visible=false
	$CanvasLayer/CanvasModulate/box2/box8/Box2.visible=false
	$CanvasLayer/CanvasModulate/box2/box9/Box2.visible=false
	$CanvasLayer/CanvasModulate/box2/box10/Box2.visible=false
	$CanvasLayer/CanvasModulate/box2/box11/Box2.visible=false
	$CanvasLayer/CanvasModulate/box2/box12/Box2.visible=false
	
	$CanvasLayer/CanvasModulate/box2/box1/Box.visible=true
	$CanvasLayer/CanvasModulate/box2/box2/Box.visible=true
	$CanvasLayer/CanvasModulate/box2/box3/Box.visible=true
	$CanvasLayer/CanvasModulate/box2/box4/Box.visible=true
	$CanvasLayer/CanvasModulate/box2/box5/Box.visible=true
	$CanvasLayer/CanvasModulate/box2/box6/Box.visible=true
	$CanvasLayer/CanvasModulate/box2/box7/Box.visible=true
	$CanvasLayer/CanvasModulate/box2/box8/Box.visible=true
	$CanvasLayer/CanvasModulate/box2/box9/Box.visible=true
	$CanvasLayer/CanvasModulate/box2/box10/Box.visible=true
	$CanvasLayer/CanvasModulate/box2/box11/Box.visible=true
	$CanvasLayer/CanvasModulate/box2/box12/Box.visible=true
	on_button_pressed()


func challengecompleted():
	await get_tree().create_timer(2).timeout
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
	await get_tree().create_timer(5).timeout
	##animaiton
	$ghostlayer/ColorRect.visible=false
	$ghostlayer/Diarypage.visible=false
	$ghostlayer/Label10.visible=false
	$ghostlayer/Label11.visible=false
	$ghostlayer/Label12.visible=false
	$ghostlayer/Insidebox.visible=true
	$ghostlayer/Glove.visible=true
	$ghostlayer/Bloodblanket.visible=false
	if Global.character == "girlGhost":
		$ghostlayer/ghosttext4.play("girl")
	if Global.character == "boyGhost":
		$ghostlayer/ghosttext4.play("boy")
	await $ghostlayer/ghosttext4.animation_finished
	$ghostlayer/Insidebox.visible=false
	$ghostlayer/Glove.visible=false
	#$ghostlayer/Label14.visible=true
	$ghostlayer/blobGhostPlayer.position.x=725
	$ghostlayer/blobGhostPlayer.position.y=737
	await atticmodulate()
	await afterpuzzle()
	$ghostlayer/AnimationPlayer.play("death")
	await $ghostlayer/AnimationPlayer.animation_finished
	if Global.character == "girlGhost":
		$ghostlayer/ghosttext5.play("girl")
	if Global.character == "boyGhost":
		$ghostlayer/ghosttext5.play("boy")
	await $ghostlayer/ghosttext5.animation_finished
	$ghostlayer/ColorRect.visible=true
	$ghostlayer/choice.visible=true
	$ghostlayer/choice/CollisionShape2D.disabled=false
	$ghostlayer/choice/CollisionShape2D2.disabled=false
	
func choice1():
	Global.ending = 1
	$ghostlayer/ghosttext6/GirlGhost.visible=false
	$ghostlayer/ghosttext6/BoyGhost.visible=false
	$ghostlayer/choice.visible=false
	$ghostlayer/choice/CollisionShape2D.disabled=true
	$ghostlayer/choice/CollisionShape2D2.disabled=true
	$ghostlayer/ColorRect.visible=false
	if Global.character =="girlGhost":
		$ghostlayer/ghosttext6.play("girl")
	if Global.character =="boyGhost":
		$ghostlayer/ghosttext6.play("boy")
	await $ghostlayer/ghosttext6.animation_finished
	var player = $ghostlayer/blobGhostPlayer
	await fade_out_node(player, 2.5)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/endcreds.tscn")

func choice2():
	Global.ending = 2
	$ghostlayer/ghosttext6/GirlGhost.visible=false
	$ghostlayer/ghosttext6/BoyGhost.visible=false
	$ghostlayer/choice.visible=false
	$ghostlayer/choice/CollisionShape2D.disabled=true
	$ghostlayer/choice/CollisionShape2D2.disabled=true
	if Global.character =="girlGhost":
		$ghostlayer/ghosttext7.play("girl")
	if Global.character =="boyGhost":
		$ghostlayer/ghosttext7.play("boy")
	await $ghostlayer/ghosttext7.animation_finished
	$ghostlayer/Label14.visible=true
	$ghostlayer/scenetrigger/CollisionShape2D.disabled=false
	
	
func fade_out_node(node: CanvasItem, duration := 2.0) -> void:
	var elapsed := 0.0

	while elapsed < duration:
		elapsed += get_process_delta_time()
		var t := elapsed / duration
		node.modulate.a = lerp(1.0, 0.0, t)
		await get_tree().process_frame

	node.modulate.a = 0.0

	
	
