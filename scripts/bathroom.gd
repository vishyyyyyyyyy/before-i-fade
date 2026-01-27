extends Node2D
var segment_starts := [0.0, 3.0]
var segment_ends   := [2.0, 6.0]
var dialogue_active := false
var segment_index := 0
var animating := true
@onready var anim := $CanvasLayer3/AnimationPlayer

func _ready():
	
	$SceneTrigger/CollisionShape2D.disabled=true
	$CanvasLayer3/AnimationPlayer.play("text")
	dialogue_active = true  
	await $CanvasLayer3/AnimationPlayer.animation_finished


func _on_texture_button_pressed() -> void:
	$ColorRect2/TextureButton/AudioStreamPlayer2D.play()


func _process(_delta):
	if animating and anim.current_animation_position >= segment_ends[segment_index]:
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
	$CanvasLayer3/Label3.visible=true
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
			
  
