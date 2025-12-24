extends Node2D


@onready var narration_label: Label = $ghostlayer/explorelabel
@onready var explore_node: Node = $explore
var clicked_objects := {} 
var time_left_seconds

func _ready() -> void:
	$CanvasLayer3/CanvasModulate/Tv.visible=true
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
		#$ghostlayer/explorelabel.visible=true
		#unlockexplore()
		challenge()

func unlockexplore():
	$explore/CanvasLayer/bookshelf/CollisionShape2D.disabled=false
	$explore/CanvasLayer/clock/CollisionShape2D.disabled=false
	$explore/CanvasLayer/couch/CollisionShape2D.disabled=false
	$explore/CanvasLayer/table/CollisionShape2D.disabled=false
	$explore/CanvasLayer/tv/CollisionShape2D.disabled=false
	$explore/CanvasLayer/rug/CollisionShape2D.disabled=false
	$explore/CanvasLayer/flower/CollisionShape2D.disabled=false
	$explore/CanvasLayer/piano/CollisionShape2D.disabled=false
	
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
		challenge()
	
		
func all_non_photos_clicked() -> bool:
	var non_desk = ["bookshelf", "clock", "table", "couch", "tv", "flower", "rug"]
	for name in non_desk:
		if not clicked_objects.has(name): 
			return false
	return true

func challenge():
	$ghostlayer/explorelabel.visible=false
	$CanvasLayer3/CanvasModulate/Tv.visible=false
	$explore/CanvasLayer/bookshelf/CollisionShape2D.disabled=true
	$explore/CanvasLayer/clock/CollisionShape2D.disabled=true
	$explore/CanvasLayer/couch/CollisionShape2D.disabled=true
	$explore/CanvasLayer/table/CollisionShape2D.disabled=true
	$explore/CanvasLayer/tv/CollisionShape2D.disabled=true
	$explore/CanvasLayer/rug/CollisionShape2D.disabled=true
	$explore/CanvasLayer/flower/CollisionShape2D.disabled=true
	$explore/CanvasLayer/piano/CollisionShape2D.disabled=true
	$ghostlayer/Music.visible=true
	#if Global.character == "boyGhost":
		#$ghostlayer/ghosttext3.play("boy")
	#if Global.character == "girlGhost":
		#$ghostlayer/ghosttext3.play("girl")
	#await $ghostlayer/ghosttext3.animation_finished
