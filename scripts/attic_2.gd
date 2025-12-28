extends Node2D


func _ready() -> void:
	Global.ending= 2
	$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	$ghostlayer/Bloodblanket.visible=true
	await atticmodulate()
	$ghostlayer/Label2.visible=true
	$ghostlayer/Phone.visible=true
	await get_tree().create_timer(0.5).timeout
	$ghostlayer/Phone2.visible=true
	await get_tree().create_timer(2).timeout
	if Global.character == "girlGhost":
		$ghostlayer/idle/girl.visible=false
		$ghostlayer/chars2girl.play("kill")
		await $ghostlayer/chars2girl.animation_finished
		$ghostlayer/Label2.visible=false
		$ghostlayer/AnimationPlayer.play("end")
		$ghostlayer/idle/girl.visible=false
		$ghostlayer/Phone2.visible=false
		$ghostlayer/Phone.visible=false
		$ghostlayer/blobGhostPlayer.position.x=1205
		$ghostlayer/blobGhostPlayer.position.y=641
		await $ghostlayer/AnimationPlayer.animation_finished
		$ghostlayer/ghosttext.play("girl")
		await $ghostlayer/ghosttext.animation_finished
		await get_tree().create_timer(0.3).timeout
		await fade_out_node($ghostlayer/blobGhostPlayer, 2.5)
		get_tree().change_scene_to_file("res://scenes/endcreds.tscn")
		
		
	if Global.character == "boyGhost":
		$ghostlayer/idle/boy.visible=true
		$ghostlayer/chars2boy.play("death")
		await $ghostlayer/chars2boy.animation_finished
		$ghostlayer/Label2.visible=false
		$ghostlayer/AnimationPlayer.play("end")
		$ghostlayer/idle/boy.visible=false
		$ghostlayer/Phone2.visible=false
		$ghostlayer/Phone.visible=false
		$ghostlayer/blobGhostPlayer.position.x=1205
		$ghostlayer/blobGhostPlayer.position.y=641
		await $ghostlayer/AnimationPlayer.animation_finished
		$ghostlayer/ghosttext.play("boy")
		await $ghostlayer/ghosttext.animation_finished
		await get_tree().create_timer(0.3).timeout
		await fade_out_node($ghostlayer/blobGhostPlayer, 2.5)
		get_tree().change_scene_to_file("res://scenes/endcreds.tscn")
		

	
func atticmodulate():
	##past char in modulations
	if Global.character =="boyGhost":
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		$ghostlayer/idle/boy.visible=true
		$ghostlayer/Bloodblanket.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
		$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
		$ghostlayer/idle/boy.visible=false
		$ghostlayer/Bloodblanket.visible=true
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		$ghostlayer/Bloodblanket.visible=false
		$ghostlayer/idle/boy.visible=true
		
	if Global.character =="girlGhost":
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		$ghostlayer/idle/girl.visible=true
		$ghostlayer/Bloodblanket.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
		$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
		$ghostlayer/idle/girl.visible=false
		$ghostlayer/Bloodblanket.visible=true
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		$ghostlayer/Bloodblanket.visible=false
		$ghostlayer/idle/girl.visible=true
	
func fade_out_node(node: CanvasItem, duration := 2.0) -> void:
	var elapsed := 0.0

	while elapsed < duration:
		elapsed += get_process_delta_time()
		var t := elapsed / duration
		node.modulate.a = lerp(1.0, 0.0, t)
		await get_tree().process_frame

	node.modulate.a = 0.0

	
	
