extends Node2D

func _ready() -> void:
	$CanvasLayer5/Label.visible=true
	$desk.diaryentry2.connect(diaryentry2)
	
func diaryentry2():
	if Global.character=="boyGhost":
		$CanvasLayer4/diaryentry2.play("boytext")
		await $CanvasLayer4/diaryentry2.animation_finished
		$CanvasLayer4/Area2D.visible=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
	if Global.character=="girlGhost":
		$CanvasLayer4/diaryentry2.play("boytext")
		await $CanvasLayer4/diaryentry2.animation_finished
		$CanvasLayer4/Area2D.visible=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
