extends Node2D

@onready var canvas = $CanvasModulate
@onready var narration_label: Label = $Label3
@onready var explore_node: Node2D = $explore 

var clicked_objects := {} 

func _ready():
	$Deskcloseup.visible=false
	$Label3.visible=false
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
	# Enable collisions
	$explore/safe/CollisionShape2D.disabled = false
	$explore/bed/CollisionShape2D.disabled = false
	$explore/window/CollisionShape2D.disabled = false
	$explore/calendar/CollisionShape2D.disabled = false
	$explore/desk/CollisionShape2D.disabled = false
	$explore/rug/CollisionShape2D.disabled = false

	# Connect Area2D clicked signals
	var areas = {
		"safe": $explore/safe,
		"bed": $explore/bed,
		"window": $explore/window,
		"calendar": $explore/calendar,
		"rug": $explore/rug,
		"desk": $explore/desk
	}

	for name in areas.keys():
		var area_node = areas[name]
		if area_node is Area2D:
			area_node.clicked.connect(func(text):
				_on_object_clicked(text, name)
			)
func _on_object_clicked(text: String, area_name: String):
	# If desk clicked before finishing others
	if area_name == "desk" and not all_non_desk_clicked():
		narration_label.text = "Let's finish looking at everything else first."
		narration_label.visible = true
		return
	
	# Mark this area as clicked
	clicked_objects[area_name] = true

	# Update label
	narration_label.text = text
	narration_label.visible = true

	# If desk clicked after everything else, trigger scene change
	if area_name == "desk" and all_non_desk_clicked():
		diaryOverlay()
		
func all_non_desk_clicked() -> bool:
	var non_desk = ["safe", "bed", "window", "calendar", "rug"]
	for name in non_desk:
		if not clicked_objects.has(name):
			return false
	return true

func diaryOverlay():
	$CanvasLayer/blobGhostPlayer.visible=false
	$Deskcloseup.visible=true
	#disable click collisions
	$explore/safe/CollisionShape2D.disabled=true
	$explore/bed/CollisionShape2D.disabled=true
	$explore/window/CollisionShape2D.disabled=true
	$explore/calendar/CollisionShape2D.disabled=true
	$explore/desk/CollisionShape2D.disabled=true
	$explore/rug/CollisionShape2D.disabled=true
