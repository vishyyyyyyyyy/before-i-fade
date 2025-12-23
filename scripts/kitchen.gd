extends Node2D

@onready var narration_label: Label = $ghostlayer/explorelabel
@onready var explore_node: Node = $explore
var clicked_objects := {} 
var time_left_seconds

func _ready() -> void:
	$CanvasLayer4/ColorRect3.visible=false
	$CanvasLayer4/ColorRect2.visible=false
	$ghostlayer/scenetrigger/CollisionShape2D.disabled=false
	Global.reusabledesk += 1
	$CanvasLayer4/Node3/continue.pressed.connect(on_button_pressed)
	$CanvasLayer4/foodchoice.challengecompleted.connect(challengecompleted)
	$CanvasLayer/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer2/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer3/CanvasModulate.modulate = Color(0.094, 0.323, 0.28) 
	start()
	
func _process(delta: float) -> void:
	time_left_seconds = $CanvasLayer4/Node3/Timer2.time_left
	$CanvasLayer4/Node3/Label5.text = "%.1f" % time_left_seconds
func start():
	if Global.character == "boyGhost":
		$ghostlayer/ghosttext1.play("boy")
		await $ghostlayer/ghosttext1.animation_finished
		await get_tree().create_timer(0.5).timeout
		await kitchenmodulate()
		$ghostlayer/aunttext.play("boy")
		await $ghostlayer/aunttext.animation_finished
		$ghostlayer/ghosttext2.play("boy")
		await $ghostlayer/ghosttext2.animation_finished
		unlock_explore()
		
	if Global.character == "girlGhost":
		$ghostlayer/ghosttext1.play("girl")
		await $ghostlayer/ghosttext1.animation_finished
		await get_tree().create_timer(0.5).timeout
		await kitchenmodulate()
		$ghostlayer/aunttext.play("girl")
		await $ghostlayer/aunttext.animation_finished
		$ghostlayer/ghosttext2.play("girl")
		await $ghostlayer/ghosttext2.animation_finished
		unlock_explore()
		
func kitchenmodulate():
	$CanvasLayer/CanvasModulate.modulate = Color(1,1,1,1)
	$CanvasLayer2/CanvasModulate.modulate = Color(1,1,1,1)
	$CanvasLayer3/CanvasModulate.modulate = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer2/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer3/CanvasModulate.modulate = Color(0.094, 0.323, 0.28) 
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.modulate = Color(1,1,1,1)
	$CanvasLayer2/CanvasModulate.modulate = Color(1,1,1,1)
	$CanvasLayer3/CanvasModulate.modulate = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout


func unlock_explore():
	$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=false
	$explore/CanvasLayer/cabinet/CollisionShape2D2.disabled=false
	$explore/CanvasLayer/cabinet/CollisionShape2D3.disabled=false
	$explore/CanvasLayer/cabinet/CollisionShape2D4.disabled=false
	$explore/CanvasLayer/oven/CollisionShape2D.disabled=false
	$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=false
	$explore/CanvasLayer/sink/CollisionShape2D.disabled=false
	$explore/CanvasLayer/fridge/CollisionShape2D.disabled=false
	$explore/CanvasLayer/chair/CollisionShape2D.disabled=false
	$explore/CanvasLayer/island/CollisionShape2D.disabled=false
	$explore/CanvasLayer/chair/CollisionShape2D2.disabled=false
	
	$ghostlayer/explorelabel.visible=true
	
	var areas = {
		"cabinet": $explore/CanvasLayer/cabinet,
		"oven": $explore/CanvasLayer/oven,
		"fridge": $explore/CanvasLayer/fridge,
		"chair": $explore/CanvasLayer/chair,
		"sink": $explore/CanvasLayer/sink,
		"island": $explore/CanvasLayer/island
	}
	for name in areas.keys():
			var area_node = areas[name]
			if area_node is Area2D:
				area_node.clicked.connect(func(text):
					_on_object_clicked(text, name)
			)
func _on_object_clicked(text: String, area_name: String):
	# If desk clicked before finishing others
	if area_name == "island" and not all_non_photos_clicked():
		narration_label.text = "Let's finish looking at everything else first."
		narration_label.visible = true
		return
# Mark this area as clicked
	clicked_objects[area_name] = true

	# Update label
	narration_label.text = text
	narration_label.visible = true
	
	if area_name == "fridge":
		$CanvasLayer2/CanvasModulate/TileMap3.visible=true
		$CanvasLayer2/CanvasModulate/Fridge.visible=true
		$ghostlayer/explorelabel.visible=false
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=false
		$explore/CanvasLayer/cabinet/CollisionShape2D2.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D3.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D4.disabled=true
		$explore/CanvasLayer/oven/CollisionShape2D.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=true
		$explore/CanvasLayer/sink/CollisionShape2D.disabled=true
		$explore/CanvasLayer/fridge/CollisionShape2D.disabled=true
		$explore/CanvasLayer/chair/CollisionShape2D.disabled=true
		$explore/CanvasLayer/chair/CollisionShape2D2.disabled=true
		$explore/CanvasLayer/island/CollisionShape2D.disabled=true
		if Global.character =="boyGhost":
			$CanvasLayer2/CanvasModulate/AnimationPlayer.play("boy")
		if Global.character =="girlGhost":
			$CanvasLayer2/CanvasModulate/AnimationPlayer.play("girl")
		await $CanvasLayer2/CanvasModulate/AnimationPlayer.animation_finished
		$ghostlayer/explorelabel.visible=true
		$CanvasLayer2/CanvasModulate/TileMap3.visible=false
		$CanvasLayer2/CanvasModulate/Fridge.visible=false
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=false
		$explore/CanvasLayer/cabinet/CollisionShape2D2.disabled=false
		$explore/CanvasLayer/cabinet/CollisionShape2D3.disabled=false
		$explore/CanvasLayer/cabinet/CollisionShape2D4.disabled=false
		$explore/CanvasLayer/oven/CollisionShape2D.disabled=false
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=false
		$explore/CanvasLayer/sink/CollisionShape2D.disabled=false
		$explore/CanvasLayer/fridge/CollisionShape2D.disabled=false
		$explore/CanvasLayer/chair/CollisionShape2D.disabled=false
		$explore/CanvasLayer/island/CollisionShape2D.disabled=false
		$explore/CanvasLayer/chair/CollisionShape2D2.disabled=false
		
	if area_name == "island" and all_non_photos_clicked():
		print("yes")
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D2.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D3.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D4.disabled=true
		$explore/CanvasLayer/oven/CollisionShape2D.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=true
		$explore/CanvasLayer/sink/CollisionShape2D.disabled=true
		$explore/CanvasLayer/fridge/CollisionShape2D.disabled=true
		$explore/CanvasLayer/chair/CollisionShape2D.disabled=true
		$explore/CanvasLayer/island/CollisionShape2D.disabled=true
		$explore/CanvasLayer/chair/CollisionShape2D2.disabled=true
		$ghostlayer/explorelabel.visible=false
		$CanvasLayer4/ColorRect2.visible=true
		$CanvasLayer4/Kitchen.visible=true
		if Global.character == "girlGhost":
			$CanvasLayer4/Node3/ghosttext.play("girl")
		if Global.character == "boyGhost":
			$CanvasLayer4/Node3/ghosttext.play("boy")
		await $CanvasLayer4/Node3/ghosttext.animation_finished
		$CanvasLayer4/Node3/ColorRect.visible=true
		$CanvasLayer4/Node3/Menucard.visible=true
		$CanvasLayer4/Node3/Label2.visible=true
		$CanvasLayer4/Node3/Label.visible=true
		$CanvasLayer4/Node3/Label3.visible=true
		$CanvasLayer4/Node3/continue/CollisionShape2D.disabled=false
		$CanvasLayer4/Node3/continue.visible=true
		kitchenpuzzle()
		
		
func all_non_photos_clicked() -> bool:
	var non_desk = ["cabinet", "oven", "sink", "fridge", "chair"]
	for name in non_desk:
		if not clicked_objects.has(name): 
			return false
	return true

func on_button_pressed():
	$ghostlayer/explorelabel.visible=false
	$CanvasLayer4/Node3/Timer.visible=true
	$CanvasLayer4/Node3/Label5.visible=true
	$CanvasLayer4/Node3/Label6.visible=true
	$CanvasLayer4/Node3/Timer2.start()
	$CanvasLayer4/ColorRect3.visible=true
	$CanvasLayer4/foodchoice/CollisionShape2D.disabled=false
	$CanvasLayer4/foodchoice/CollisionShape2D2.disabled=false
	$CanvasLayer4/foodchoice/CollisionShape2D3.disabled=false
	$CanvasLayer4/Flour.visible=true
	$CanvasLayer4/Radish.visible=true
	$CanvasLayer4/Strawberry.visible=true
	
func kitchenpuzzle():
	$CanvasLayer4/ColorRect2.visible=true
	$CanvasLayer4/ColorRect3.visible=true
	$CanvasLayer4/ColorRect3.visible=true
	$CanvasLayer4/Node3/Label6.visible=true
	$CanvasLayer4/Label.visible=true
	$CanvasLayer4/foodchoice.visible=true
	$CanvasLayer4/Node3/ColorRect.visible=true
	$CanvasLayer4/Node3/Menucard.visible=true
	$CanvasLayer4/Node3/Label2.visible=true
	$CanvasLayer4/Node3/Label.visible=true
	$CanvasLayer4/Node3/Label3.visible=true
	$CanvasLayer4/Node3/continue/CollisionShape2D.disabled=false
	$CanvasLayer4/Node3/continue.visible=true
	$CanvasLayer4/Kitchen.visible=true
	$CanvasLayer4/foodchoice/CollisionShape2D4.disabled=true
	
	
func challengecompleted():
	$CanvasLayer4/Node3/Label6.visible=false
	await get_tree().create_timer(2).timeout
	$CanvasLayer4/ColorRect3.visible=false
	$CanvasLayer4/Label.visible=false
	$CanvasLayer4/Node3/Diarypage.visible=true
	$CanvasLayer4/Node3/ColorRect.visible=true
	$CanvasLayer4/Node3/Diarypage.visible=true
	$CanvasLayer4/Node3/Label4.visible=true
	$CanvasLayer4/Node3/Label7.visible=true
	$CanvasLayer4/Node3/Label8.visible=true
	$ghostlayer/blobGhostPlayer.position.x=1153
	await get_tree().create_timer(5).timeout
	$CanvasLayer4/Node3/Diarypage.visible=false
	$CanvasLayer4/Node3/ColorRect.visible=false
	$CanvasLayer4/Node3/Diarypage.visible=false
	$CanvasLayer4/Node3/Label4.visible=false
	$CanvasLayer4/Node3/Label7.visible=false
	$CanvasLayer4/Node3/Label8.visible=false
	$CanvasLayer4/Kitchen9.visible=false
	$CanvasLayer4/Kitchen.visible=false
	$CanvasLayer4/Node3/Label5.visible=false
	$CanvasLayer4/Node3/Timer.visible=false
	#$CanvasLayer4/Node3/Label11.visible=false
	$CanvasLayer/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer2/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer3/CanvasModulate.modulate = Color(0.094, 0.323, 0.28) 
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.modulate = Color(1,1,1,1)
	$CanvasLayer2/CanvasModulate.modulate = Color(1,1,1,1)
	$CanvasLayer3/CanvasModulate.modulate = Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer2/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	$CanvasLayer3/CanvasModulate.modulate = Color(0.094, 0.323, 0.28)
	await get_tree().create_timer(0.5).timeout 
	$CanvasLayer4/Kitchen20.visible=true
	$CanvasLayer4/ColorRect2.visible=true
	if Global.character =="girlGhost":
		$CanvasLayer4/Node3/ghosttext2.play("girl")
	elif Global.character =="boyGhost":
		$CanvasLayer4/Node3/ghosttext2.play("boy")
	await $CanvasLayer4/Node3/ghosttext2.animation_finished
	$CanvasLayer4/Kitchen20.visible=false
	$CanvasLayer4/ColorRect2.visible=false
	$CanvasLayer4/Node3/Label11.visible=true
	$ghostlayer/scenetrigger/CollisionShape2D.disabled=false
