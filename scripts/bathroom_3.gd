extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reusabledesk += 1
	print(Global.reusabledesk)
	firsttext()
	await $CanvasLayer3/ghosttalk.animation_finished
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
	await $AudioStreamPlayer.finished
	friendCall()
	await get_tree().create_timer(16).timeout
	secondtext()
	await $CanvasLayer3/ghosttalk2.animation_finished
	$CanvasLayer3/AnimationPlayer3
	$CanvasLayer3/Node3/ColorRect.visible=true
	$CanvasLayer3/Node3/Menucard.visible=true
	$CanvasLayer3/Node3/Label2.visible=true
	$CanvasLayer3/Node3/Label.visible=true
	$CanvasLayer3/Node3/Label3.visible=true
	$CanvasLayer3/Node3/continue.visible=true
	$CanvasLayer3/Node3/continue/CollisionShape2D.disabled=false
	$CanvasLayer3/Node3/continue.pressed.connect(_on_button_pressed)
	$CanvasLayer3/PresentTile.challengecompleted.connect(afterpuzzle)
	$CanvasLayer3/comb.combpress.connect(combpress)
func firsttext():
	if Global.character=="girlGhost":
		$CanvasLayer3/ghosttalk.play("girltext")
	if Global.character=="boyGhost":
		$CanvasLayer3/ghosttalk.play("boytext")
	
func friendCall():
	if Global.character=="girlGhost":
		$CanvasLayer3/friendphone.play("friendcallgirl")
		await $CanvasLayer3/friendphone.animation_finished
	if Global.character=="boyGhost":
		$CanvasLayer3/friendphone.play("friendcallboy")
		await $CanvasLayer3/friendphone.animation_finished
func secondtext():
	if Global.character=="girlGhost":
		$CanvasLayer3/ghosttalk2.play("girltext2")
		await 	$CanvasLayer3/ghosttalk2.animation_finished
	if Global.character=="boyGhost":
		$CanvasLayer3/ghosttalk2.play("boytext2")
		await 	$CanvasLayer3/ghosttalk2.animation_finished
		
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


func afterpuzzle():
	$CanvasLayer3/PresentTile/tile1.visible=false
	$CanvasLayer3/PresentTile/tile1/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile2.visible=false
	$CanvasLayer3/PresentTile/tile2/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile3.visible=false
	$CanvasLayer3/PresentTile/tile3/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile4.visible=false
	$CanvasLayer3/PresentTile/tile4/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile5.visible=false
	$CanvasLayer3/PresentTile/tile5/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile6.visible=false
	$CanvasLayer3/PresentTile/tile6/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile7.visible=false
	$CanvasLayer3/PresentTile/tile7/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile8.visible=false
	$CanvasLayer3/PresentTile/tile8/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile9.visible=false
	$CanvasLayer3/PresentTile/tile9/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile10.visible=false
	$CanvasLayer3/PresentTile/tile10/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile11.visible=false
	$CanvasLayer3/PresentTile/tile11/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile12.visible=false
	$CanvasLayer3/PresentTile/tile12/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile13.visible=false
	$CanvasLayer3/PresentTile/tile13/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile14.visible=false
	$CanvasLayer3/PresentTile/tile14/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile15.visible=false
	$CanvasLayer3/PresentTile/tile15/CollisionShape2D.disabled=true
	$CanvasLayer3/PresentTile/tile16.visible=false
	$CanvasLayer3/PresentTile/tile16/CollisionShape2D.disabled=true
	$CanvasLayer3/pasttile.visible=true
	$CanvasLayer3/Node3/ColorRect.visible=true
	$CanvasLayer3/presenttile.visible=true
	$CanvasLayer3/Node3/Correct.visible=true
	$CanvasLayer3/Node3/ColorRect.visible=true
	$CanvasLayer3/comb/Comb.visible=true
	$CanvasLayer3/Node3/Label5.visible=true
	$CanvasLayer3/Label4.visible=false
	await get_tree().create_timer(2).timeout
	$CanvasLayer/TileMap.visible=false
	$CanvasLayer3/Node3/Timer.visible=false
	$"CanvasLayer3/Past Tiles".visible=false
	$"CanvasLayer3/Present Tiles".visible=false
	$CanvasLayer3/pasttile.visible=false
	$CanvasLayer3/Node3/ColorRect.visible=false
	$CanvasLayer3/presenttile.visible=false
	$CanvasLayer3/Node3/Correct.visible=false
	$CanvasLayer3/Node3/Label5.visible=false
	$CanvasLayer3/Node3/ColorRect.visible=false
	$CanvasLayer3/comb/Comb.visible=true
	$CanvasLayer3/Node3/Label5.visible=false
	$CanvasLayer3/comb.visible=true
	$CanvasLayer3/Label4.visible=false
	$CanvasLayer3/ColorRect3.visible=true
	$CanvasLayer3/Diarypage.visible=true
	$CanvasLayer3/Label2.visible=true
	$CanvasLayer3/Label.visible=true
	$CanvasLayer3/Label3.visible=true
	await get_tree().create_timer(2).timeout
	$CanvasLayer3/ColorRect3.visible=false
	$CanvasLayer3/Diarypage.visible=false
	$CanvasLayer3/Label2.visible=false
	$CanvasLayer3/Label.visible=false
	$CanvasLayer3/Label3.visible=false
	$CanvasLayer3/comb/CollisionShape2D.disabled=false
	$CanvasLayer3/Label6.visible=true
	modulatebackghost()



func combpress():
	$CanvasLayer3/Label6.visible=false
	$CanvasLayer3/TileMap3.visible=true
	$CanvasLayer3/comb.visible=false
	$CanvasLayer3/Comb2.visible=true
	$CanvasLayer3/comb/CollisionShape2D.disabled=true
	if Global.character=="girlGhost":
		$CanvasLayer3/ghosttalk3.play("girlghost")
		await $"CanvasLayer3/ghosttalk3".animation_finished
		$CanvasLayer3/TileMap3.visible=false
		$CanvasLayer3/comb.visible=true
		$CanvasLayer3/Comb2.visible=false
		$CanvasLayer3/Label7.visible=true
	if Global.character=="boyGhost":
		$CanvasLayer3/ghosttalk3.play("boyghost")
		await $"CanvasLayer3/ghosttalk3".animation_finished
		$CanvasLayer3/TileMap3.visible=false
		$CanvasLayer3/comb.visible=true
		$CanvasLayer3/Comb2.visible=false
		$CanvasLayer3/Label7.visible=true
		
func modulatebackghost():
	$CanvasLayer/TileMap.visible=true
	$CanvasModulate.color = Color(0.0, 0.994, 0.816)
	$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.323, 0.28)
	$CanvasLayer4/CanvasModulate2.color= Color(0.094, 0.323, 0.28)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
	$CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate2.color = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasModulate.color = Color(0.0, 0.994, 0.816)
	$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.323, 0.28)
	$CanvasLayer4/CanvasModulate2.color= Color(0.094, 0.323, 0.28)
	$Area2D/CollisionShape2D.disabled=false
