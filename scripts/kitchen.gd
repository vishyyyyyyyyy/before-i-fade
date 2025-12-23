extends Node2D

@onready var narration_label: Label = $ghostlayer/explorelabel
@onready var explore_node: Node = $explore
var clicked_objects := {} 

func _ready() -> void:
	Global.reusabledesk += 1
	unlock_explore()
	#$CanvasLayer/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	#$CanvasLayer2/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	#$CanvasLayer3/CanvasModulate.modulate = Color(0.094, 0.323, 0.28) 
	#start()
	#
#func start():
	#if Global.character == "boyGhost":
		#$ghostlayer/ghosttext1.play("boy")
		#await $ghostlayer/ghosttext1.animation_finished
		#await get_tree().create_timer(0.5).timeout
		#await kitchenmodulate()
		#$ghostlayer/aunttext.play("boy")
		#await $ghostlayer/aunttext.animation_finished
		#$ghostlayer/ghosttext2.play("boy")
		#await $ghostlayer/ghosttext2.animation_finished
		#
	#if Global.character == "girlGhost":
		#$ghostlayer/ghosttext1.play("girl")
		#await $ghostlayer/ghosttext1.animation_finished
		#await get_tree().create_timer(0.5).timeout
		#await kitchenmodulate()
		#$ghostlayer/aunttext.play("girl")
		#await $ghostlayer/aunttext.animation_finished
		#$ghostlayer/ghosttext2.play("girl")
		#await $ghostlayer/ghosttext2.animation_finished
		#
#func kitchenmodulate():
	#$CanvasLayer/CanvasModulate.modulate = Color(1,1,1,1)
	#$CanvasLayer2/CanvasModulate.modulate = Color(1,1,1,1)
	#$CanvasLayer3/CanvasModulate.modulate = Color(1,1,1,1)
	#await get_tree().create_timer(0.5).timeout
	#$CanvasLayer/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	#$CanvasLayer2/CanvasModulate.modulate = Color(0.0, 0.992, 0.816)
	#$CanvasLayer3/CanvasModulate.modulate = Color(0.094, 0.323, 0.28) 
	#await get_tree().create_timer(0.5).timeout
	#$CanvasLayer/CanvasModulate.modulate = Color(1,1,1,1)
	#$CanvasLayer2/CanvasModulate.modulate = Color(1,1,1,1)
	#$CanvasLayer3/CanvasModulate.modulate = Color(1,1,1,1)
	#await get_tree().create_timer(0.5).timeout


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
	$explore/CanvasLayer/chair/CollisionShape2D2.disabled=true
	
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
		
	# If desk clicked after everything else, trigger scene change
	if area_name == "island" and all_non_photos_clicked():
		print("yes")
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=false
		$explore/CanvasLayer/cabinet/CollisionShape2D2.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D3.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D4.disabled=true
		$explore/CanvasLayer/oven/CollisionShape2D.disabled=true
		$explore/CanvasLayer/cabinet/CollisionShape2D.disabled=true
		$explore/CanvasLayer/sink/CollisionShape2D.disabled=true
		$explore/CanvasLayer/fridge/CollisionShape2D.disabled=true
		$explore/CanvasLayer/chair/CollisionShape2D.disabled=true
		$explore/CanvasLayer/island/CollisionShape2D.disabled=true
		$ghostlayer/explorelabel.visible=false
		#if Global.character == "girlGhost":

		#if Global.character == "boyGhost":
		
			
func all_non_photos_clicked() -> bool:
	var non_desk = ["cabinet", "oven", "sink", "fridge", "chair"]
	for name in non_desk:
		if not clicked_objects.has(name): 
			return false
	return true



		
	
