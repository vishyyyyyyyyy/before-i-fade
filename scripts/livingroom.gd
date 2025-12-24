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
	$ghostlayer/pianokeys.challengecompleted.connect(challengecompleted)
	$ghostlayer/continue.pressed.connect(pressed)
	text()
func _process(delta: float) -> void:
	time_left_seconds = $ghostlayer/Timer2.time_left
	$ghostlayer/Label8.text = "%.1f" % time_left_seconds

func text():
	if Global.character =="girlGhost":
		$ghostlayer/ghosttext1.play("girl")
	if Global.character == "boyGhost":
		$ghostlayer/ghosttext1.play("boy")
	await $ghostlayer/ghosttext1.animation_finished
	modulatelivingroom()
	await modulatelivingroom()
	
func modulatelivingroom():
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer3/CanvasModulate.color =Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	$CanvasLayer4/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer3/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer3/CanvasModulate.color =Color(1,1,1,1)
	if Global.character == "boyGhost":
		$ghostlayer/extext.play("boy")
		await $ghostlayer/extext.animation_finished
		$ghostlayer/ghosttext2.play("boy")
		await $ghostlayer/ghosttext2.animation_finished
		$ghostlayer/explorelabel.visible=true
		unlockexplore()
	if Global.character == "girlGhost":
		$ghostlayer/extext.play("girl")
		await $ghostlayer/extext.animation_finished
		$ghostlayer/ghosttext2.play("girl")
		await $ghostlayer/ghosttext2.animation_finished
		$ghostlayer/explorelabel.visible=true
		unlockexplore()

func unlockexplore():
	$ghostlayer/explorelabel.visible=true
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
	$ghostlayer/Label.visible=true
	$ghostlayer/Label2.visible=true
	$ghostlayer/Label3.visible=true
	$ghostlayer/Label4.visible=true
	if Global.character == "boyGhost":
		$ghostlayer/ghosttext3.play("boy")
	if Global.character == "girlGhost":
		$ghostlayer/ghosttext3.play("girl")
	await $ghostlayer/ghosttext3.animation_finished
	$ghostlayer/ColorRect.visible=true
	$ghostlayer/Menucard.visible=true
	$ghostlayer/Label5.visible=true
	$ghostlayer/Label6.visible=true
	$ghostlayer/Label7.visible=true
	$ghostlayer/continue.visible=true
	$ghostlayer/continue/CollisionShape2D.disabled=false

func pressed():
	$ghostlayer/Label9.visible=true
	$ghostlayer/Label.visible=true
	$ghostlayer/Label2.visible=true
	$ghostlayer/Label3.visible=true
	$ghostlayer/Label4.visible=true
	$ghostlayer/Label8.visible=true
	$ghostlayer/ColorRect.visible=false
	$ghostlayer/Menucard.visible=false
	$ghostlayer/Label5.visible=false
	$ghostlayer/Label6.visible=false
	$ghostlayer/Label7.visible=false
	$ghostlayer/continue.visible=false
	$ghostlayer/Timer.visible=true
	$ghostlayer/Timer2.start()
	$ghostlayer/pianokeys/CollisionShape2D.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D2.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D3.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D4.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D5.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D6.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D7.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D8.disabled=false
	$ghostlayer/pianokeys/CollisionShape2D9.disabled=false
	
func challengecompleted():
	$ghostlayer/Label.visible=false
	$ghostlayer/Label2.visible=false
	$ghostlayer/Label3.visible=false
	$ghostlayer/Label4.visible=false
	$ghostlayer/Label9.visible=false
	$explore/CanvasLayer/bookshelf/CollisionShape2D.disabled=true
	$explore/CanvasLayer/clock/CollisionShape2D.disabled=true
	$explore/CanvasLayer/couch/CollisionShape2D.disabled=true
	$explore/CanvasLayer/table/CollisionShape2D.disabled=true
	$explore/CanvasLayer/tv/CollisionShape2D.disabled=true
	$explore/CanvasLayer/rug/CollisionShape2D.disabled=true
	$explore/CanvasLayer/flower/CollisionShape2D.disabled=true
	$explore/CanvasLayer/piano/CollisionShape2D.disabled=true
	$ghostlayer/pianokeys/CollisionShape2D6/ColorRect.visible=false
	$ghostlayer/Correct.visible=false
	$ghostlayer/ColorRect.visible=true
	$ghostlayer/Diarypage.visible=true
	$ghostlayer/Label10.visible=true
	$ghostlayer/Label11.visible=true
	$ghostlayer/Label12.visible=true
	await get_tree().create_timer(5).timeout
	$ghostlayer/ColorRect.visible=false
	$ghostlayer/Diarypage.visible=false
	$ghostlayer/Label10.visible=false
	$ghostlayer/Label11.visible=false
	$ghostlayer/Label12.visible=false
	$ghostlayer/blobGhostPlayer.position.x = 2128
	$ghostlayer/blobGhostPlayer.position.y = 399
	if Global.character == "girlGhost":
		$ghostlayer/ghosttext4.play("girl")
	if Global.character == "boyGhost":
		$ghostlayer/ghosttext4.play("boy")
	await $ghostlayer/ghosttext4.animation_finished
	$CanvasLayer3/CanvasModulate/Tv.visible=true
	$ghostlayer/blobGhostPlayer.position.x = 2128
	$ghostlayer/blobGhostPlayer.position.y = 399
	$ghostlayer/Music.visible=false
	$ghostlayer/Music2.visible=false
	$ghostlayer/Music3.visible=false
	$CanvasLayer/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	$CanvasLayer4/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer3/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1)
	$CanvasLayer4/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer3/CanvasModulate.color =Color(1,1,1,1)
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	$CanvasLayer4/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer3/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	$ghostlayer/scentrigger/CollisionShape2D.disabled=false
	Global.livingroom = 1
	$ghostlayer/Label14.visible=true
	
