extends Node2D

func _ready() -> void:
	$CanvasLayer/Label3.visible=true
	$desk.diaryentry2.connect(diaryentry2)
	
	
func diaryentry2():
	pass
