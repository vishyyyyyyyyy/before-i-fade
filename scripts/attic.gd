extends Node2D

func _ready() -> void:
	$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	$ghostlayer/Bloodblanket.visible=true
	text()

func text():
	if Global.character == "girlGhost":
		$ghostlayer/ghosttext.play("girl")
	if Global.character == "boyGhost":
		$ghostlayer/ghosttext.play("boy")
	await $ghostlayer/ghosttext.animation_finished
	atticmodulate()
	await atticmodulate()
	if Global.character == "girlGhost":
		$ghostlayer/pastchar1.play("girl")
	if Global.character == "boyGhost":
		$ghostlayer/pastchar1.play("boy")
	await $ghostlayer/pastchar1.animation_finished
	$ghostlayer/AnimationPlayer.play("death")
	await $ghostlayer/AnimationPlayer.animation_finished
	$ghostlayer/Bloodblanket.visible=true
	afterpuzzle()
	$ghostlayer/AnimationPlayer.play("death")
	await $ghostlayer/AnimationPlayer.animation_finished
		#
	
func atticmodulate():
	#past char in modulations
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
	$ghostlayer/Bloodblanket.visible=false
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	$ghostlayer/Bloodblanket.visible=true
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
	$ghostlayer/Bloodblanket.visible=false

func afterpuzzle():
	#past char and then ex walk in close but not too close
		if Global.character == "girlGhost":
			$ghostlayer/pastchar2.play("girl")
		if Global.character == "boyGhost":
			$ghostlayer/pastchar2.play("boy")
		await $ghostlayer/pastchar2.animation_finished
	#after animation finished, ex comes in closer fast so it looks like stab,
	#then it'll go to the screen with blood on it 
