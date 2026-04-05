extends Node2D


var segment_data := [
	{ "starts": [0.0], "ends": [2.0] }
]
@onready var anim_players := [
	$CanvasLayer4/diaryentry5
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
	if not dialogue_active or not animating:
		return
	
	if anim.current_animation == "":
		return # No animation playing, skip

	if anim.get_current_animation_position() >= segment_ends[segment_index]:
		anim.pause()
		animating = false
		
func _ready() -> void:
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"
		
	$CanvasLayer5/Label.visible=true
	$desk.diaryentry5.connect(diaryentry5)

func _input(event):
	if not dialogue_active:
		return

	if event.is_action_pressed("ui_accept") and not event.is_echo():
		textskip()	
	
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

			
func end_dialogue():
	dialogue_active = false
	anim.stop()

	print("Dialogue finished:", anim_index)
	if anim_index == 0:
		$CanvasLayer4/diaryentry5/GirlGhost.visible=false
		$CanvasLayer4/diaryentry5/BoyGhost.visible=false
		$CanvasLayer4/diaryentry5/Label.visible=false
		$CanvasLayer4/diaryentry5/skip.visible=false
		
		
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
		await get_tree().create_timer(0.8).timeout
		await start_dialogue(0)
		$CanvasLayer3/reread/left.disabled=false
		$CanvasLayer3/reread/Ghostarrow.visible=true
		$ghostlayer/blobGhostPlayer.position.x=1907
		$ghostlayer/blobGhostPlayer.position.y=602
		$CanvasLayer4/Area2D.visible=true
		$desk/CollisionPolygon2D.disabled=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
		$SceneTrigger/CollisionShape2D.disabled=true
