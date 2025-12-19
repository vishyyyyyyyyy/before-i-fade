extends Node2D

@onready var canvas = $CanvasModulate

func _ready():
	#$SceneTrigger/CollisionShape2D.disabled =true
	#$CanvasLayer/AnimationPlayer.play("type_text")
	#await $CanvasLayer/AnimationPlayer.animation_finished
	#$SceneTrigger/CollisionShape2D.disabled = false
	modulate()
	
func modulate():
	if Global.character == "girlGhost":
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer2/CanvasModulate2.color = Color(1,1,1,1)
		$CanvasModulate.color = Color(1,1,1,1)
		$CanvasModulate/Calendar2.visible=true
		await get_tree().create_timer(0.5).timeout
		$CanvasModulate/Calendar2.visible=false
		$CanvasModulate.color = Color(0.0, 0.994, 0.816)
		$CanvasLayer2/CanvasModulate2.color = Color(0.094, 0.323, 0.28)
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer2/CanvasModulate2.color = Color(1,1,1,1)
		$CanvasModulate.color = Color(1,1,1,1)
		$CanvasModulate/Calendar2.visible=true
		$CanvasLayer/AnimationPlayer2.play("girlghost")
		
	if Global.character == "boyGhost":
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer2/CanvasModulate2.color = Color(1,1,1,1)
		$CanvasModulate.color = Color(1,1,1,1)
		$CanvasModulate/Calendar2.visible=true
		await get_tree().create_timer(0.5).timeout
		$CanvasModulate/Calendar2.visible=false
		$CanvasModulate.color = Color(0.0, 0.994, 0.816)
		$CanvasLayer2/CanvasModulate2.color = Color(0.094, 0.323, 0.28)
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer2/CanvasModulate2.color = Color(1,1,1,1)
		$CanvasModulate.color = Color(1,1,1,1)
		$CanvasModulate/Calendar2.visible=true
		$CanvasLayer/AnimationPlayer2.play("boyghost")

		
