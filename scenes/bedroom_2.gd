extends Node2D

@onready var canvas = $CanvasModulate
@onready var narration_label: Label = $Label3
@onready var explore_node: Node2D = $explore 

func _ready():
	narration_label.visible = false
	$explore/safe/CollisionShape2D.disabled=true
	$explore/bed/CollisionShape2D.disabled=true
	$explore/window/CollisionShape2D.disabled=true
	$explore/calendar/CollisionShape2D.disabled=true
	$explore/desk/CollisionShape2D.disabled=true
	$explore/rug/CollisionShape2D.disabled=true
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
		await $CanvasLayer/AnimationPlayer2.animation_finished
		$Label3.visible=true
		unlock_explore()
		
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
		await $CanvasLayer/AnimationPlayer2.animation_finished
		$Label3.visible=true
		unlock_explore()

		
func unlock_explore():
	$explore/safe/CollisionShape2D.disabled=false
	$explore/bed/CollisionShape2D.disabled=false
	$explore/window/CollisionShape2D.disabled=false
	$explore/calendar/CollisionShape2D.disabled=false
	$explore/desk/CollisionShape2D.disabled=false
	$explore/rug/CollisionShape2D.disabled=false
	for area in explore_node.get_children():
		if area is Area2D:
			area.clicked.connect(_on_object_clicked)

func _on_object_clicked(text: String):
	narration_label.text = text
	narration_label.visible = true
