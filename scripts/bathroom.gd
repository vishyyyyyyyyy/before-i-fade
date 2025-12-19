extends Node2D

func _ready():
	#$SceneTrigger/CollisionShape2D.disabled =true
	$CanvasLayer3/AnimationPlayer.play("text")
	await $CanvasLayer3/AnimationPlayer.animation_finished
	#$CanvasLayer/Label3.visible=true
	#$SceneTrigger/CollisionShape2D.disabled = false
