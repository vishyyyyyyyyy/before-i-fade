extends Node2D

func _ready() -> void:
	Global.reusablehallway =4
	
	if Global.reusablehallway ==4:
		$ghostlayer/Label.visible=true
		$ghostlayer/scenetrigger/CollisionShape2D.disabled=true
		$ghostlayer/scenetrigger/CollisionShape2D2.disabled=false
		Global.kitchen = 4
		print(Global.kitchen)
