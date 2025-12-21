extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#firsttext()
	#await $CanvasLayer3/AnimationPlayer.animation_finished
	#await get_tree().create_timer(0.5).timeout
	#$CanvasLayer/TileMap.visible=false
	#$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
	#$CanvasModulate.color = Color(1,1,1,1)
	#$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	#await get_tree().create_timer(0.5).timeout
	#$CanvasLayer/TileMap.visible=true
	#$CanvasModulate.color = Color(0.0, 0.994, 0.816)
	#$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.323, 0.28)
	#$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	#await get_tree().create_timer(0.5).timeout
	#$CanvasLayer/TileMap.visible=false
	#$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
	#$CanvasModulate.color = Color(1,1,1,1)
	#$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	#await get_tree().create_timer(0.5).timeout
	#$AudioStreamPlayer.play()
	#await $AudioStreamPlayer.finished
	#friendCall()
	#await get_tree().create_timer(16).timeout
	#secondtext()
	#await $CanvasLayer3/AnimationPlayer3.animation_finished
	#$CanvasLayer3/AnimationPlayer3
	$CanvasLayer3/Node3/ColorRect.visible=true
	$CanvasLayer3/Node3/Menucard.visible=true
	$CanvasLayer3/Node3/Label2.visible=true
	$CanvasLayer3/Node3/Label.visible=true
	$CanvasLayer3/Node3/Label3.visible=true
	$CanvasLayer3/Node3/continue.visible=true
	$CanvasLayer3/Node3/continue/CollisionShape2D.disabled=false
	$CanvasLayer3/Node3/continue.pressed.connect(_on_button_pressed)

func firsttext():
	if Global.character=="girlGhost":
		$CanvasLayer3/AnimationPlayer.play("girltext")
	if Global.character=="boyGhost":
		$CanvasLayer3/AnimationPlayer2.play("boytext")
	
func friendCall():
	if Global.character=="girlGhost":
		$CanvasLayer3/AnimationPlayer2.play("friendcallgirl")
		await $CanvasLayer3/AnimationPlayer2.animation_finished
	if Global.character=="boyGhost":
		$CanvasLayer3/AnimationPlayer2.play("friendcallboy")
		await $CanvasLayer3/AnimationPlayer2.animation_finished
func secondtext():
	if Global.character=="girlGhost":
		$CanvasLayer3/AnimationPlayer3.play("girltext2")
		await $CanvasLayer3/AnimationPlayer3.animation_finished
	if Global.character=="boyGhost":
		$CanvasLayer3/AnimationPlayer3.play("boytext2")
		await $CanvasLayer3/AnimationPlayer3.animation_finished
		
func _on_button_pressed():
	print("Signal received in main script!")
	$CanvasLayer3/presenttile.visible=true
	$CanvasLayer3/pasttile.visible=true
	$CanvasLayer3/Node3/ColorRect.visible=true
	$CanvasLayer3/Node3/Timer.visible=true
	$"CanvasLayer3/Past Tiles".visible=true
	$"CanvasLayer3/Present Tiles".visible=true
	$CanvasLayer3/Node3/Label5.visible=true
	enable_show_tilecollision()
	$CanvasLayer3/Label4.visible=true

func enable_show_tilecollision():
	$CanvasLayer3/Node3/Timer2.start()
	$CanvasLayer3/PresentTile/tile1.visible=true
	$CanvasLayer3/PresentTile/tile1/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile2.visible=true
	$CanvasLayer3/PresentTile/tile2/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile3.visible=true
	$CanvasLayer3/PresentTile/tile3/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile4.visible=true
	$CanvasLayer3/PresentTile/tile4/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile5.visible=true
	$CanvasLayer3/PresentTile/tile5/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile6.visible=true
	$CanvasLayer3/PresentTile/tile6/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile7.visible=true
	$CanvasLayer3/PresentTile/tile7/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile8.visible=true
	$CanvasLayer3/PresentTile/tile8/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile9.visible=true
	$CanvasLayer3/PresentTile/tile9/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile10.visible=true
	$CanvasLayer3/PresentTile/tile10/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile11.visible=true
	$CanvasLayer3/PresentTile/tile11/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile12.visible=true
	$CanvasLayer3/PresentTile/tile12/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile13.visible=true
	$CanvasLayer3/PresentTile/tile13/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile14.visible=true
	$CanvasLayer3/PresentTile/tile14/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile15.visible=true
	$CanvasLayer3/PresentTile/tile15/CollisionShape2D.disabled=false
	$CanvasLayer3/PresentTile/tile16.visible=true
	$CanvasLayer3/PresentTile/tile16/CollisionShape2D.disabled=false
