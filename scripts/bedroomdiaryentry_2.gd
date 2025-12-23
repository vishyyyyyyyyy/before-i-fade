extends Node2D

func _ready() -> void:
	Global.reusabledesk = 3
	$CanvasLayer5/Label.visible=true
	$desk.diaryentry2.connect(diaryentry2)
	$desk.diaryentry3.connect(diaryentry3)
	$desk.diaryentry4.connect(diaryentry4)
	if Global.reusabledesk >=2:
		$CanvasLayer/blobGhostPlayer.position.x = 200
	
func diaryentry2():
	if Global.character=="boyGhost":
		$CanvasLayer4/diaryentry2.play("boytext")
		await $CanvasLayer4/diaryentry2.animation_finished
		$CanvasLayer4/Area2D.visible=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
	if Global.character=="girlGhost":
		$CanvasLayer4/diaryentry2.play("girltext")
		await $CanvasLayer4/diaryentry2.animation_finished
		$CanvasLayer4/Area2D.visible=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
		
func diaryentry3():
	if Global.character=="boyGhost":
		$CanvasLayer4/diaryentry3.play("boytext")
		await $CanvasLayer4/diaryentry3.animation_finished
		$CanvasLayer4/Area2D.visible=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
	if Global.character=="girlGhost":
		$CanvasLayer4/diaryentry3.play("girltext")
		await $CanvasLayer4/diaryentry3.animation_finished
		$CanvasLayer4/Area2D.visible=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false

func diaryentry4():
	if Global.character=="boyGhost":
		$CanvasLayer4/diaryentry3.play("boytext")
		await $CanvasLayer4/diaryentry3.animation_finished
		$CanvasLayer4/Area2D.visible=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
	if Global.character=="girlGhost":
		$CanvasLayer4/diaryentry3.play("girltext")
		await $CanvasLayer4/diaryentry3.animation_finished
		$CanvasLayer4/Area2D.visible=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
