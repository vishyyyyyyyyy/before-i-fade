extends Node2D

func _ready() -> void:
	if Global.character == "girlGhost":
		$CanvasLayer3/CanvasModulate/Girlframe5.visible=false
	if Global.character == "boyGhost":
		$CanvasLayer3/CanvasModulate/Girlframe5.visible=true
	
