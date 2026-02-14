extends Node2D
var segment_data := [
	{ "starts": [0.0], "ends": [2.0] }, 
	{ "starts": [0.0, 4.0, 8.0, 12.0], "ends": [2.0, 6.0, 10.0, 14.0] },
]
@onready var anim_players := [
	$CanvasLayer4/diaryentry5,
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


func _ready() -> void:
	$CanvasLayer5/Label.visible=true
	$ghostlayer/LineEdit.editable =false
	$desk.diaryentry5.connect(diaryentry5)
	$CanvasLayer4/Area2D.pressed.connect(pressed)

func _process(_delta):
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
		$CanvasLayer4/diaryentry5/GirlGhost.visible=false
		$CanvasLayer4/diaryentry5/BoyGhost.visible=false
		$CanvasLayer4/diaryentry5/Label.visible=false
		$CanvasLayer4/diaryentry5/skip.visible=false
		if Global.character =="girlGhost":
			anim_name = "friendtextGIRL"

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
		$CanvasLayer4/diaryentry5/GirlGhost.visible=false
		$CanvasLayer4/diaryentry5/BoyGhost.visible=false
		$CanvasLayer4/diaryentry5/Label.visible=false
		$CanvasLayer4/diaryentry5/skip.visible=false
		
			
	if anim_index ==1:
		$ghostlayer/ghosttext/Label4.visible=false
		$ghostlayer/ghosttext/GirlGhost.visible=false
		$ghostlayer/ghosttext/skip.visible=false
		$ghostlayer/ghosttext/BoyGhost.visible=false
		
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


func diaryentry5():
	await start_dialogue(0)
	$ghostlayer/blobGhostPlayer.position.x=1907
	$ghostlayer/blobGhostPlayer.position.y=602
	$CanvasLayer3/CanvasModulate/ColorRect2.visible=false
	$ghostlayer/blobGhostPlayer.position.x=1897
	$ghostlayer/blobGhostPlayer.position.y=555
	$CanvasLayer4/Area2D.visible=true
	$desk/CollisionPolygon2D.disabled=true
	$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
	#$SceneTrigger/CollisionShape2D.disabled=true
		
func pressed():
	$CanvasLayer3/CanvasModulate/ColorRect2.visible=false
	await start_dialogue(1)
	$ghostlayer/Label.visible=true
	$ghostlayer/Area2D/CollisionShape2D.disabled=false
