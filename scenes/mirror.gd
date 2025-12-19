extends Node2D

func _ready():
	$Node/Area2D/CollisionPolygon2D.disabled=true
	$Sponge.visible=false
	$AnimationPlayer.play("text")
	await $AnimationPlayer.animation_finished
	$Label2.visible=true
	$Sponge.visible=true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Node/Area2D/CollisionPolygon2D.disabled=false
