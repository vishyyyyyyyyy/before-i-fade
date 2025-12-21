extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	firsttext()
	await $CanvasLayer3/AnimationPlayer.animation_finished
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/TileMap.visible=false
	$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
	$CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/TileMap.visible=true
	$CanvasModulate.color = Color(0.0, 0.994, 0.816)
	$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.323, 0.28)
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/TileMap.visible=false
	$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
	$CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$AudioStreamPlayer.play()
	await get_tree().create_timer(3).timeout
	friendCall()
	

func firsttext():
	if Global.character=="girlGhost":
		$CanvasLayer3/AnimationPlayer.play("girltext")

	if Global.character=="boyGhost":
		$CanvasLayer3/AnimationPlayer2.play("boytext")
	

	
func friendCall():
	if Global.character=="girlGhost":
		$CanvasLayer3/AnimationPlayer2.play("friendcallgirl")
	if Global.character=="boyGhost":
		$CanvasLayer3/AnimationPlayer2.play("friendcallboy")
