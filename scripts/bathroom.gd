extends Node2D
var segment_starts := [0.0, 3.0]
var segment_ends   := [2.0, 6.0]
var dialogue_active := false
var segment_index := 0
var animating := true
var player_in_area = false
@onready var anim := $CanvasLayer3/AnimationPlayer


func _ready():
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"
	$CanvasLayer3/AnimationPlayer.play("text")
	dialogue_active = true  
	await $CanvasLayer3/AnimationPlayer.animation_finished

	
func _on_texture_button_pressed() -> void:
	$ColorRect2/TextureButton/AudioStreamPlayer2D.play()


func _process(_delta):
	if animating and anim.current_animation_position >= segment_ends[segment_index]:
		anim.pause()
		animating = false
	if player_in_area and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/mirror.tscn")

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
	$CanvasLayer3/AnimationPlayer/skip.visible=false

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
			

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "blobGhostPlayer":
		player_in_area = true
		$CanvasLayer2/Node2D/EAnim.play("E")
	print(body.name)

func _on_area_2d_body_exited(body: Node2D) -> void:
	player_in_area = false
	$CanvasLayer2/Node2D/EAnim.stop()
	$CanvasLayer2/Node2D/EAnim/letterE.visible = false
