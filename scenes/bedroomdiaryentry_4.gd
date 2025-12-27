extends Node2D


func _ready() -> void:
	$CanvasLayer5/Label.visible=true
	$ghostlayer/LineEdit.editable =false
	$desk.diaryentry5.connect(diaryentry5)
	$CanvasLayer4/Area2D.pressed.connect(pressed)
	
func diaryentry5():
	if Global.character=="boyGhost":
		$CanvasLayer4/diaryentry5.play("boy")
		await $CanvasLayer4/diaryentry5.animation_finished
		$CanvasLayer4/Area2D.visible=true
		$desk/CollisionPolygon2D.disabled=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
		$SceneTrigger/CollisionShape2D.disabled=true
	if Global.character=="girlGhost":
		$CanvasLayer4/diaryentry5.play("girl")
		await $CanvasLayer4/diaryentry5.animation_finished
		$CanvasLayer3/CanvasModulate/ColorRect2.visible=false
		$ghostlayer/blobGhostPlayer.position.x=1897
		$ghostlayer/blobGhostPlayer.position.y=555
		$CanvasLayer4/Area2D.visible=true
		$desk/CollisionPolygon2D.disabled=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
		#$SceneTrigger/CollisionShape2D.disabled=true
		
func pressed():
	$CanvasLayer3/CanvasModulate/ColorRect2.visible=false
	if Global.character=="boyGhost":
		$ghostlayer/ghosttext.play("girl")
	if Global.character=="girlGhost":
		$ghostlayer/ghosttext.play("girl")
	await $ghostlayer/ghosttext.animation_finished
	$ghostlayer/Label.visible=true
	$ghostlayer/Area2D/CollisionShape2D.disabled=false
