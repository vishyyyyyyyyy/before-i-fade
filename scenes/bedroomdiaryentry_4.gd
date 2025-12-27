extends Node2D


func _ready() -> void:
	$CanvasLayer5/Label.visible=true
	$desk.diaryentry5.connect(diaryentry5)

func diaryentry5():
	if Global.character=="boyGhost":
		$CanvasLayer4/diaryentry4.play("boy")
		await $CanvasLayer4/diaryentry4.animation_finished
		$CanvasLayer4/Area2D.visible=true
		$desk/CollisionPolygon2D.disabled=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
		$CanvasLayer5/Label4.visible=true
		$SceneTrigger/CollisionShape2D.disabled=true
	if Global.character=="girlGhost":
		$CanvasLayer4/diaryentry4.play("girl")
		await $CanvasLayer4/diaryentry4.animation_finished
		$CanvasLayer4/Area2D.visible=true
		$desk/CollisionPolygon2D.disabled=true
		$CanvasLayer4/Area2D/CollisionShape2D.disabled=false
		$CanvasLayer5/Label4.visible=true
		$SceneTrigger/CollisionShape2D.disabled=true
		
