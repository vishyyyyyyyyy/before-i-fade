extends Node2D

@onready var narration_label: Label = $CanvasLayer/Label
@onready var explore_node: Node = $explore

var clicked_objects := {} 

func _ready() -> void:
	Global.reusabledesk += 1
	ghosttext1()

func ghosttext1():
	if Global.character == "girlGhost":
		$CanvasLayer/ghosttext1.play("girltext")
		await $CanvasLayer/ghosttext1.animation_finished
		modulate()
	if Global.character == "boyGhost":
		$CanvasLayer/ghosttext1.play("boytext")
		await $CanvasLayer/ghosttext1.animation_finished
		modulate()
		
func modulate():
	if Global.character == "girlGhost":
		$CanvasLayer3/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=true
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=true
		$CanvasLayer3/CanvasModulate/Boyframe5.visible=true
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece2.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece3.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece4.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer3/CanvasModulate.color = Color(0.0, 0.992, 0.816)
		$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.322, 0.278)
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=false
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=false
		$CanvasLayer3/CanvasModulate/Boyframe5.visible=false
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece2.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece3.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece4.visible=true
		
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer3/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=true
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=true
		$CanvasLayer3/CanvasModulate/Boyframe5.visible=true
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece2.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece3.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece4.visible=false
		await get_tree().create_timer(0.5).timeout
		$"CanvasLayer/neighbor talk".play("neighbortext")
		await $"CanvasLayer/neighbor talk".animation_finished
		$CanvasLayer/ghosttext2.play("girlghosttext")
		await $CanvasLayer/ghosttext2.animation_finished
		$CanvasLayer/Label.visible=true
		$explore/CanvasLayer/flowers/CollisionShape2D.disabled=false
		$explore/CanvasLayer/flowers/CollisionShape2D2.disabled=false
		$explore/CanvasLayer/lamp/CollisionShape2D.disabled=false
		$explore/CanvasLayer/photos/CollisionShape2D.disabled=false
		unlock_explore()
		
	if Global.character == "boyGhost":
		$CanvasLayer3/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=true
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=true
		$CanvasLayer3/CanvasModulate/Girlframe5.visible=true
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece2.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece3.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece4.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer3/CanvasModulate.color = Color(0.0, 0.992, 0.816)
		$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.322, 0.278)
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=false
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=false
		$CanvasLayer3/CanvasModulate/Girlframe5.visible=false
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece2.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece3.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece4.visible=true
		
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer3/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=true
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=true
		$CanvasLayer3/CanvasModulate/Girlframe5.visible=true
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece2.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece3.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece4.visible=false
		await get_tree().create_timer(0.5).timeout
		$"CanvasLayer/neighbor talk".play("neighbortext")
		await $"CanvasLayer/neighbor talk".animation_finished
		$CanvasLayer/ghosttext2.play("boyghosttext")
		await $CanvasLayer/ghosttext2.animation_finished
		$CanvasLayer/Label.visible=true
		$explore/CanvasLayer/flowers/CollisionShape2D.disabled=false
		$explore/CanvasLayer/flowers/CollisionShape2D2.disabled=false
		$explore/CanvasLayer/lamp/CollisionShape2D.disabled=false
		$explore/CanvasLayer/photos/CollisionShape2D.disabled=false
		unlock_explore()

func unlock_explore():
	$CanvasLayer/Label.visible=true
	
	var areas = {
		"photos": $explore/CanvasLayer/photos,
		"lamp": $explore/CanvasLayer/lamp,
		"flowers": $explore/CanvasLayer/flowers
	}
	for name in areas.keys():
			var area_node = areas[name]
			if area_node is Area2D:
				area_node.clicked.connect(func(text):
					_on_object_clicked(text, name)
			)
func _on_object_clicked(text: String, area_name: String):
	# If desk clicked before finishing others
	if area_name == "photos" and not all_non_photos_clicked():
		narration_label.text = "Let's finish looking at everything else first."
		narration_label.visible = true
		return
# Mark this area as clicked
	clicked_objects[area_name] = true

	# Update label
	narration_label.text = text
	narration_label.visible = true

	# If desk clicked after everything else, trigger scene change
	if area_name == "photos" and all_non_photos_clicked():
		$explore/CanvasLayer/flowers/CollisionShape2D.disabled=true
		$explore/CanvasLayer/flowers/CollisionShape2D2.disabled=true
		$explore/CanvasLayer/lamp/CollisionShape2D.disabled=true
		$explore/CanvasLayer/photos/CollisionShape2D.disabled=true
		$CanvasLayer/Label2.visible=false
		if Global.character == "girlGhost":
			$CanvasLayer/TileMap3.visible=true
			$CanvasLayer/Auntframe.visible=true
			$CanvasLayer/Boyframe.visible=true
			$CanvasLayer/Friendframe.visible=true
			$CanvasLayer/Neigborframe.visible=true
			$CanvasLayer/ghosttext3.play("girltext")
			await $CanvasLayer/ghosttext3.animation_finished
			$CanvasLayer/TileMap3.visible=false
			$CanvasLayer/Auntframe.visible=false
			$CanvasLayer/Boyframe.visible=false
			$CanvasLayer/Friendframe.visible=false
			$CanvasLayer/Neigborframe.visible=false
		if Global.character == "boyGhost":
			$CanvasLayer/TileMap3.visible=true
			$CanvasLayer/Auntframe.visible=true
			$CanvasLayer/Friendframe.visible=true
			$CanvasLayer/Girlframe.visible=true
			$CanvasLayer/Neigborframe.visible=true
			$CanvasLayer/ghosttext3.play("boytext")
			await $CanvasLayer/ghosttext3.animation_finished
			$CanvasLayer/TileMap3.visible=false
			$CanvasLayer/Auntframe.visible=false
			$CanvasLayer/Friendframe.visible=false
			$CanvasLayer/Girlframe.visible=false
			$CanvasLayer/Neigborframe.visible=false
func all_non_photos_clicked() -> bool:
	var non_desk = ["lamp", "flowers"]
	for name in non_desk:
		if not clicked_objects.has(name): 
			return false
	return true

func hallwaypuzzle():
	pass
