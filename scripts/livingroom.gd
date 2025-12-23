extends Node2D

func _ready() -> void:
	$CanvasLayer/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	$CanvasLayer4/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer3/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	text()

func text():
	#if Global.character =="girlGhost":
		#$ghostlayer/ghosttext1.play("girl")
	#if Global.character == "boyGhost":
		#$ghostlayer/ghosttext1.play("boy")
	#await $ghostlayer/ghosttext1.animation_finished
	#modulatelivingroom()
	await modulatelivingroom()
	
func modulatelivingroom():
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer3/CanvasModulate.color =Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	$CanvasLayer4/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer3/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer3/CanvasModulate.color =Color(1,1,1,1)
	if Global.character == "boyGhost":
		$ghostlayer/extext.play("boy")
		await $ghostlayer/extext.animation_finished
		$ghostlayer/ghosttext2.play("boy")
		await $ghostlayer/ghosttext2.animation_finished
	if Global.character == "girlGhost":
		$ghostlayer/extext.play("girl")
		await $ghostlayer/extext.animation_finished
		$ghostlayer/ghosttext2.play("girl")
		await $ghostlayer/ghosttext2.animation_finished
