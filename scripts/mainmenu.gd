extends Node2D
func _ready() -> void:
	$Node/Play/CollisionShape2D.disabled=true
	$Node/Music/CollisionShape2D.disabled=true
	$Node4/AnimationPlayer.play("fadein")
	await $Node4/AnimationPlayer.animation_finished
	$Node/Play/CollisionShape2D.disabled=false
	$Node/Music/CollisionShape2D.disabled=false
