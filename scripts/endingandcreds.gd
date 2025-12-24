extends Node2D
func _ready() -> void:
	$countdown.play("countdown")
	await $countdown.animation_finished
	$Menucard.visible=false
