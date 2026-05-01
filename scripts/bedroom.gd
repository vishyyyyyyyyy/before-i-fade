extends Node2D
var segment_starts := [0.0, 3.0]
var segment_ends   := [2.0, 7.0]
var dialogue_active := false
var segment_index := 0
var animating := true
var escCounter = 0
@onready var anim := $CanvasLayer/AnimationPlayer


func _ready():
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"
	$SceneTrigger/CollisionShape2D.disabled =true
	$CanvasLayer/AnimationPlayer2.play("panandzoom")
	dialogue_active = false
	await $CanvasLayer/AnimationPlayer2.animation_finished
	$Ghost1.visible=false
	$CanvasLayer/blobGhostPlayer.visible=true
	$CanvasLayer/blobGhostPlayer.position.x = 1209.0
	$CanvasLayer/blobGhostPlayer.position.y = 528.0
	$CanvasLayer/AnimationPlayer.play("type_text")
	dialogue_active = true  
		
func _process(_delta):
	if animating and anim.is_playing() and anim.current_animation_position >= segment_ends[segment_index]:
		anim.pause()
		animating = false

func _input(event):
	if not dialogue_active:
		return

	if event.is_action_pressed("ui_accept"):
		textskip()

func end_dialogue():
	dialogue_active = false
	anim.stop()

	print("Dialogue finished")
	$CanvasLayer/Label3.visible = true
	$SceneTrigger/CollisionShape2D.disabled = false
	$CanvasLayer/AnimationPlayer/skip.visible=false
	$CanvasLayer/Node2D/arrow.play("arrow")

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
			end_dialogue()
