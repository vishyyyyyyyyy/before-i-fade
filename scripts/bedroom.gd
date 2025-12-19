extends Node2D

func _ready():
	$SceneTrigger/CollisionShape2D.disabled =true
	$CanvasLayer/AnimationPlayer.play("type_text")
	await $CanvasLayer/AnimationPlayer.animation_finished
	$CanvasLayer/Label3.visible=true
	$SceneTrigger/CollisionShape2D.disabled = false
