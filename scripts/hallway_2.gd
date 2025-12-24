extends Node2D

func _ready() -> void:
	
	if Global.reusablehallway ==4:
		$CanvasLayer/Label5.visible=true
		$CanvasLayer/blobGhostPlayer.position.x = 2188.0
		Global.kitchen = 3
		$"CanvasLayer/scene trigger/CollisionShape2D".disabled=false
		$"CanvasLayer/scene trigger/CollisionShape2D2".disabled=true
	
	
	if Global.reusablehallway == 1:
		$CanvasLayer/Label4.visible=true
		Global.kitchen =1
		
	if Global.kitchen == 2:
		$"CanvasLayer/scene trigger/CollisionShape2D".disabled=true
		$"CanvasLayer/scene trigger/CollisionShape2D2".disabled=false
		Global.reusablehallway  = 3
		$CanvasLayer/blobGhostPlayer.position.x = 178
		
	

	print("bathroom count: " + str(Global.bathroomCount))
	print("reusabledesk count: " + str(Global.reusabledesk))
	print("reusablehallway count: " + str(Global.reusablehallway))
	print("kitchen: " + str(Global.kitchen))
	print("livingroom: " + str(Global.livingroom))
