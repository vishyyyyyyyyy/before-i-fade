extends Node2D
var segment_starts := [0.0, 3.0]
var segment_ends   := [2.0, 7.0]
var dialogue_active := false
var segment_index := 0
var animating := true
@onready var anim := $CanvasLayer/AnimationPlayer


@onready var pause_menu = $CanvasPause/PauseMenu



func toggle_pause():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	
func _ready():
	$SceneTrigger/CollisionShape2D.disabled =true
	$CanvasLayer/AnimationPlayer.play("type_text")
	dialogue_active = true  
	await $CanvasLayer/AnimationPlayer.animation_finished
	$CanvasLayer/Label3.visible=true
	$SceneTrigger/CollisionShape2D.disabled = false

func _process(_delta):
	if animating and anim.current_animation_position >= segment_ends[segment_index]:
		anim.pause()
		animating = false

func _input(event):
	if not dialogue_active:
		return

	if event.is_action_pressed("ui_accept"):
		textskip()
	
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func end_dialogue():
	dialogue_active = false
	anim.stop()

	print("Dialogue finished")
	$CanvasLayer/Label3.visible = true
	$SceneTrigger/CollisionShape2D.disabled = false

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
  


func _on_resume_pressed() -> void:
	get_tree().paused = false
	$CanvasPause/PauseMenu.visible = false
