extends Node2D


@onready var narration_label: Label = $ghostlayer/explorelabel
@onready var explore_node: Node = $explore
var clicked_objects := {} 
var time_left_seconds

func _ready() -> void:
	$CanvasLayer/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	$CanvasLayer4/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer3/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	text()

func text():
	#if Global.character =="girlGhost":
		#$ghostlayer/ghosttext1.play("girl")
	#if Global.character == "boyGhost":
		#$ghostlayer/ghosttext1.play("boy")
	#await $ghostlayer/ghosttext1.animation_finished
	#modulatelivingroom()
	await modulatelivingroom()
	
func modulatelivingroom():
	#$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
	#$CanvasLayer4/CanvasModulate.color = Color(1,1,1,1) 
	#$CanvasLayer3/CanvasModulate.color =Color(1,1,1,1)
	#await get_tree().create_timer(0.5).timeout
	#$CanvasLayer/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	#$CanvasLayer4/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	#$CanvasLayer3/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	#await get_tree().create_timer(0.5).timeout
	#$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
	#$CanvasLayer4/CanvasModulate.color = Color(1,1,1,1) 
	#$CanvasLayer3/CanvasModulate.color =Color(1,1,1,1)
	#if Global.character == "boyGhost":
		#$ghostlayer/extext.play("boy")
		#await $ghostlayer/extext.animation_finished
		#$ghostlayer/ghosttext2.play("boy")
		#await $ghostlayer/ghosttext2.animation_finished
	#if Global.character == "girlGhost":
		#$ghostlayer/extext.play("girl")
		#await $ghostlayer/extext.animation_finished
		#$ghostlayer/ghosttext2.play("girl")
		#await $ghostlayer/ghosttext2.animation_finished
		$ghostlayer/explorelabel.visible=true
		unlockexplore()

func unlockexplore():
	
	var areas = {
		"bookshelf": $explore/CanvasLayer/bookshelf,
		"clock": $explore/CanvasLayer/clock,
		"couch": $explore/CanvasLayer/couch,
		"table": $explore/CanvasLayer/table,
		"tv": $explore/CanvasLayer/tv,
		"rug": $explore/CanvasLayer/rug,
		"flower": $explore/CanvasLayer/flower,
		"piano": $explore/CanvasLayer/piano,
		
	}
	for name in areas.keys():
			var area_node = areas[name]
			if area_node is Area2D:
				area_node.clicked.connect(func(text):
					_on_object_clicked(text, name)
			)
func _on_object_clicked(text: String, area_name: String):
	# If desk clicked before finishing others
	if area_name == "piano" and not all_non_photos_clicked():
		narration_label.text = "Let's finish looking at everything else first."
		narration_label.visible = true
		return
# Mark this area as clicked
	clicked_objects[area_name] = true

	# Update label
	narration_label.text = text
	narration_label.visible = true
	
	if area_name == "piano" and all_non_photos_clicked():
		print("yes")
	
		
func all_non_photos_clicked() -> bool:
	var non_desk = ["bookshelf", "clock", "table", "couch", "tv", "flower", "rug"]
	for name in non_desk:
		if not clicked_objects.has(name): 
			return false
	return true
