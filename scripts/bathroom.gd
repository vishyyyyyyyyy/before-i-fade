extends Node2D

func _ready():
	
	$SceneTrigger/CollisionShape2D.disabled=true
	$CanvasLayer3/AnimationPlayer.play("text")
	await $CanvasLayer3/AnimationPlayer.animation_finished
	$CanvasLayer3/Label3.visible=true
	$SceneTrigger/CollisionShape2D.disabled = false



func _on_texture_button_pressed() -> void:
	$ColorRect2/TextureButton/AudioStreamPlayer2D.play()
