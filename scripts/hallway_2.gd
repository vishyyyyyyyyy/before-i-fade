extends Node2D

func _ready() -> void:
	if Global.reusablehallway == 1:
		$CanvasLayer/Label4.visible=true
		Global.kitchen =1
		
	if Global.kitchen == 2:
		$"CanvasLayer/scene trigger/CollisionShape2D".disabled=true
		$"CanvasLayer/scene trigger/CollisionShape2D2".disabled=false
		$CanvasLayer/blobGhostPlayer.position.x = 178
		
	if Global.reusablehallway ==4:
		$CanvasLayer/Label5.visible=true
		Global.kitchen = 3
	
