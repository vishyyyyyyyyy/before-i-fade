extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer3/AnimationPlayer.play("boytext")
	await $CanvasLayer3/AnimationPlayer.animation_finished
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
	$CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasModulate.color = Color(0.0, 0.994, 0.816)
	$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.323, 0.28)
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
	$CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$AudioStreamPlayer.play()
	
	
	
	
	
	if Global.character=="GirlGhost":
		$CanvasLayer3/AnimationPlayer.play("boytext")
		$AudioStreamPlayer.play()

	if Global.character=="boyGhost":
		$CanvasLayer3/AnimationPlayer.play("girltext")
		$AudioStreamPlayer.play()
