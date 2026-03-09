extends Area2D

var time_left_seconds

var segment_data := [
	{ "starts": [0.0, 4.0,], "ends": [2.0, 6.0] },  
	{ "starts": [0.0, 4.0], "ends": [2.0, 6.0] },
	{ "starts": [0.0, 4.0, 8.0, 12.0, 16.0, 20.0], "ends": [2.0, 6.0, 10.0, 14.0, 18.0, 22.0] }, #diary
	{ "starts": [0.0, 5.0, 10.0, 15.0, 20.0, 25.0], "ends": [2.0, 7.0, 12.0, 17.0, 22.0, 28.0] }, #diary
	{ "starts": [0.0, 4.0], "ends": [2.0, 6.0] }, 
]
@onready var anim_players := [
	$"../ghosttext2",
	$"../ghosttext3",
	$"../ghosttext4",
	$"../pastvideo",
	$"../ghosttext5",
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
	# Assuming LineEdit is $LineEdit
	$"../continue".pressed.connect(pressed)
	$"../LineEdit".text = ""
	$"../LineEdit".editable = false 
	$"../LineEdit".connect("text_submitted", Callable(self, "_on_text_entered"))

func _process(delta: float) -> void:
	time_left_seconds = $"../Timer2".time_left
	$"../Label5".text = "%.1f" % time_left_seconds
	
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
		$"../ghosttext2/skip".visible=false
		$"../ghosttext2/BoyGhost".visible=false
		$"../ghosttext2/GirlGhost".visible=false
		$"../ghosttext2/Label2".visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
	
	if anim_index == 2:
		$"../fridgememory/Vignette".visible=false
		$"../fridgememory/Label2".visible=false
		$"../fridgememory/GirlGhost".visible=false
		$"../fridgememory/BoyGhost".visible=false
		$"../fridgememory/Fridge".visible=false
		
		$"../ghosttext3/Label2".visible=false
		$"../ghosttext3/GirlGhost".visible=false
		$"../ghosttext3/BoyGhost".visible=false
		$"../ghosttext3/skip".visible=false
		
		$"../ghosttext2/skip".visible=false
		$"../ghosttext2/BoyGhost".visible=false
		$"../ghosttext2/GirlGhost".visible=false
		$"../ghosttext2/Label2".visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")

	if anim_index == 3:
		$"../ghosttext4/Label6".visible=false
		$"../ghosttext4/GirlGhost".visible=false
		$"../ghosttext4/BoyGhost".visible=false
		$"../ghosttext4/skip".visible=false
		
		$"../fridgememory/Vignette".visible=false
		$"../fridgememory/Label2".visible=false
		$"../fridgememory/GirlGhost".visible=false
		$"../fridgememory/BoyGhost".visible=false
		$"../fridgememory/Fridge".visible=false
		
		$"../ghosttext3/Label2".visible=false
		$"../ghosttext3/GirlGhost".visible=false
		$"../ghosttext3/BoyGhost".visible=false
		$"../ghosttext3/skip".visible=false
		
		$"../ghosttext2/skip".visible=false
		$"../ghosttext2/BoyGhost".visible=false
		$"../ghosttext2/GirlGhost".visible=false
		$"../ghosttext2/Label2".visible=false
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")


	if anim_index ==4:
		$"../pastvideo/Label6".visible=false
		$"../pastvideo/Ghostvideoboy".visible=false
		$"../pastvideo/Ghostvideogirl".visible=false
		$"../pastvideo/skip".visible=false
		$"../pastvideo/skip2".visible=false
		
		$"../ghosttext4/Label6".visible=false
		$"../ghosttext4/GirlGhost".visible=false
		$"../ghosttext4/BoyGhost".visible=false
		$"../ghosttext4/skip".visible=false
		
		$"../fridgememory/Vignette".visible=false
		$"../fridgememory/Label2".visible=false
		$"../fridgememory/GirlGhost".visible=false
		$"../fridgememory/BoyGhost".visible=false
		$"../fridgememory/Fridge".visible=false
		
		$"../ghosttext3/Label2".visible=false
		$"../ghosttext3/GirlGhost".visible=false
		$"../ghosttext3/BoyGhost".visible=false
		$"../ghosttext3/skip".visible=false
		
		$"../ghosttext2/skip".visible=false
		$"../ghosttext2/BoyGhost".visible=false
		$"../ghosttext2/GirlGhost".visible=false
		$"../ghosttext2/Label2".visible=false
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
		$"../ghosttext2/skip".visible=false
		$"../ghosttext2/BoyGhost".visible=false
		$"../ghosttext2/GirlGhost".visible=false
		$"../ghosttext2/Label2".visible=false
		
			
	if anim_index == 1:
		$"../ghosttext3/Label2".visible=false
		$"../ghosttext3/GirlGhost".visible=false
		$"../ghosttext3/BoyGhost".visible=false
		$"../ghosttext3/skip".visible=false
		
		
	if anim_index == 2: 
		$"../ghosttext4/Label6".visible=false
		$"../ghosttext4/GirlGhost".visible=false
		$"../ghosttext4/BoyGhost".visible=false
		$"../ghosttext4/skip".visible=false
	
	if anim_index == 3:
		$"../pastvideo/Label6".visible=false
		$"../pastvideo/Ghostvideoboy".visible=false
		$"../pastvideo/Ghostvideogirl".visible=false
		$"../pastvideo/skip".visible=false
		$"../pastvideo/skip2".visible=false
	
	if anim_index == 4:
		$"../ghosttext5/Label2".visible=false
		$"../ghosttext5/BoyGhost2".visible=false
		$"../ghosttext5/GirlGhost2".visible=false
		$"../ghosttext5/skip".visible=false
		
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


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		$CollisionShape2D.disabled=true
		$"../Label".visible = false
		$"../Safecloseup".visible = true
		$"../TileMap3".visible = true
		await start_dialogue(0)
		if Global.character == "girlGhost":
			$"../fridgememory".play("girl")
		if Global.character == "boyGhost":
			$"../fridgememory".play("boy")
		await $"../fridgememory".animation_finished
		await start_dialogue(1)
		$"../ColorRect".visible = true
		$"../Menucard".visible = true
		$"../Label2".visible = true
		$"../Label3".visible = true
		$"../Label4".visible = true
		$"../continue".visible = true
		$"../continue/CollisionShape2D".disabled=false

func pressed():
	$"../Timer".visible = true
	$"../Label4".visible=false
	$"../Label5".visible = true
	$"../Label6".visible = true
	$"../LineEdit".editable = true
	$"../LineEdit".visible=true
	$"../LineEdit".grab_focus() 
	$"../Timer2".start()

func _on_text_entered(new_text: String) -> void:
	if new_text.strip_edges().to_lower() == "fade":
		print("Correct!")
		$"../LineEdit".visible=false
		$"../Timer2".stop()
		$"../Correct".visible=true
		$"../AudioStreamPlayer".play()
		$"../LineEdit".editable = false
		$"../Label6".visible=false
		$"../Timer".visible=false
		$"../Label5".visible=false
		await get_tree().create_timer(2).timeout
		$"../Correct".visible=false
		$"../Safecloseup".visible=false
		$"../Opensafe".visible=true
		await start_dialogue(2)
		$"../Opensafe".visible=false
		$"../Recordscreen".visible=true
		$"../VideoStreamPlayer".play()
		await start_dialogue(3)
		$"../VideoStreamPlayer".stop()
		$"../Recordscreen".visible=false
		$"../Opensafe".visible=true
		await start_dialogue(4)
		$"../TileMap3".visible=false
		$"../Opensafe".visible=false
		$"../Label7".visible=true
		$"../../SceneTrigger/CollisionShape2D".disabled=false
		

func _on_timer_2_timeout() -> void:
	print("Incorrect")
	$"../Timer2".stop()
	$"../Wrong".visible=true
	$"../AudioStreamPlayer2".play()
	await get_tree().create_timer(2).timeout
	reset()

func reset():
	$"../LineEdit".text = ""  
	$"../Wrong".visible=false
	$"../Timer2".start()
