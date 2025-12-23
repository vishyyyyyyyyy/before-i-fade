extends Node2D

func _ready() -> void:
	Global.reusablehallway = 1
	Global.reusabledesk = 3
	
	if Global.reusablehallway == 1:
		$CanvasLayer/Label4.visible=true
		
	
