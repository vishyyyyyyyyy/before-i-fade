extends Node2D

@onready var canvas = $CanvasModulate
@onready var narration_label: Label = $Label3
@onready var explore_node: Node2D = $explore 

var clicked_objects := {} 
var deskcounter:= 0

func _ready():
	$Node2/Area2D.pressed.connect(_on_desk_area_pressed)
	$Node/Deskcloseup.visible=false
	$Label3.visible=false
	narration_label.visible = false
	$explore/safe/CollisionShape2D.disabled=true
	$explore/bed/CollisionShape2D.disabled=true
	$explore/window/CollisionShape2D.disabled=true
	$explore/calendar/CollisionShape2D.disabled=true
	$explore/desk/CollisionShape2D.disabled=true
	$explore/rug/CollisionShape2D.disabled=true
	 # Use lambda to bind the area name
	$Node/familyphoto.input_event.connect(func(area, event, shape_idx):
		_on_area_clicked(area, event, shape_idx, "familyphoto")
		)
	
	$Node/diary.input_event.connect(func(area, event, shape_idx):
		_on_area_clicked(area, event, shape_idx, "diary")
		)
	modulate()
	
func modulate():
	if Global.character == "girlGhost":
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/AnimationPlayer3/girlIdle.visible = true
		$CanvasLayer2/CanvasModulate2.color = Color(1,1,1,1)
		$CanvasModulate.color = Color(1,1,1,1)
		$CanvasModulate/Calendar2.visible=true
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/AnimationPlayer3/girlIdle.visible = false
		$CanvasModulate/Calendar2.visible=false
		$CanvasModulate.color = Color(0.0, 0.994, 0.816)
		$CanvasLayer2/CanvasModulate2.color = Color(0.094, 0.323, 0.28)
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/AnimationPlayer3/girlIdle.visible = true
		$CanvasLayer2/CanvasModulate2.color = Color(1,1,1,1)
		$CanvasModulate.color = Color(1,1,1,1)
		$CanvasModulate/Calendar2.visible=true
		$CanvasLayer/AnimationPlayer2.play("girlghost")
		await $CanvasLayer/AnimationPlayer2.animation_finished
		$CanvasLayer/AnimationPlayer3/friend.visible = true
		await get_tree().create_timer(1.0).timeout
		$CanvasLayer/AnimationPlayer.play("friendtextGIRL")
		await $CanvasLayer/AnimationPlayer.animation_finished
		await get_tree().create_timer(1.0).timeout
		$CanvasLayer/AnimationPlayer3/girlIdle.visible = false
		$CanvasLayer/AnimationPlayer3/girlWalk.visible = true
		$CanvasLayer/AnimationPlayer3.play("exitGirl")
		await $CanvasLayer/AnimationPlayer3.animation_finished
		$Label3.visible=true
		unlock_explore()
		
	if Global.character == "boyGhost":
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/AnimationPlayer3/boyIdle.visible = true
		$CanvasLayer2/CanvasModulate2.color = Color(1,1,1,1)
		$CanvasModulate.color = Color(1,1,1,1)
		$CanvasModulate/Calendar2.visible=true
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/AnimationPlayer3/boyIdle.visible = false
		$CanvasModulate/Calendar2.visible=false
		$CanvasModulate.color = Color(0.0, 0.994, 0.816)
		$CanvasLayer2/CanvasModulate2.color = Color(0.094, 0.323, 0.28)
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer2/CanvasModulate2.color = Color(1,1,1,1)
		$CanvasModulate.color = Color(1,1,1,1)
		$CanvasModulate/Calendar2.visible=true
		$CanvasLayer/AnimationPlayer3/boyIdle.visible = true
		$CanvasLayer/AnimationPlayer2.play("boyghost")
		await $CanvasLayer/AnimationPlayer2.animation_finished
		$CanvasLayer/AnimationPlayer3/friend.visible = true
		await get_tree().create_timer(1.0).timeout
		$CanvasLayer/AnimationPlayer.play("friendtextBOY")
		await $CanvasLayer/AnimationPlayer.animation_finished
		await get_tree().create_timer(1.0).timeout
		$CanvasLayer/AnimationPlayer3/boyIdle.visible = false
		$CanvasLayer/AnimationPlayer3/boyWalk.visible = true
		$CanvasLayer/AnimationPlayer3.play("exit")
		await $CanvasLayer/AnimationPlayer3.animation_finished
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
	
@onready var family_photo_area: Area2D = $Node/familyphoto
@onready var diary_area: Area2D = $Node/diary

func diaryOverlay():
	$CanvasLayer2/CanvasModulate2/Door.visible=false
	$CanvasLayer2/CanvasModulate2/Door2.visible=false
	$Label3.visible=false
	$CanvasLayer/blobGhostPlayer.visible=false
	$Node/Deskcloseup.visible=true
	#disable click collisions
	$explore/safe/CollisionShape2D.disabled=true
	$explore/bed/CollisionShape2D.disabled=true
	$explore/window/CollisionShape2D.disabled=true
	$explore/calendar/CollisionShape2D.disabled=true
	$explore/desk/CollisionShape2D.disabled=true
	$explore/rug/CollisionShape2D.disabled=true
	
	#enable photo and diary collisions
	$Node/familyphoto/CollisionShape2D.disabled =false
	$Node/diary/CollisionPolygon2D.disabled=false


func _on_area_clicked(area, event, shape_idx, area_name):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		match area_name:
			"familyphoto":
				if Global.character == "boyGhost":
					$Node/AnimationPlayer.play("boyfamilyphoto")
					$Node/familyphoto/CollisionShape2D.disabled=true
					$Node/diary/CollisionPolygon2D.disabled=true
					await $Node/AnimationPlayer.animation_finished
					$Node/familyphoto/CollisionShape2D.disabled=false
					$Node/diary/CollisionPolygon2D.disabled=false
					deskcounter +=1
					
				else:
					$Node/AnimationPlayer.play("girlfamilyphoto")
					$Node/familyphoto/CollisionShape2D.disabled=true
					$Node/diary/CollisionPolygon2D.disabled=true
					await $Node/AnimationPlayer.animation_finished
					$Node/familyphoto/CollisionShape2D.disabled=false
					$Node/diary/CollisionPolygon2D.disabled=false
					deskcounter +=1
			"diary":
				if Global.character == "boyGhost":
					$Node/AnimationPlayer2.play("boydiarytext")
					$Node/familyphoto/CollisionShape2D.disabled=true
					$Node/diary/CollisionPolygon2D.disabled=true
					await $Node/AnimationPlayer2.animation_finished
					$Node/diary/CollisionPolygon2D.disabled=false
					$Node/familyphoto/CollisionShape2D.disabled=false
					deskcounter +=1
				else:
					$Node/AnimationPlayer2.play("girldiarytext")
					$Node/diary/CollisionPolygon2D.disabled=true
					$Node/familyphoto/CollisionShape2D.disabled=true
					await $Node/AnimationPlayer2.animation_finished
					$Node/diary/CollisionPolygon2D.disabled=false
					$Node/familyphoto/CollisionShape2D.disabled=false
					deskcounter +=1
					
		if deskcounter >=1:
			$Node2/Area2D/CollisionShape2D.disabled=false
			$Node2/Area2D.visible=true


func _on_desk_area_pressed():
	$Node/Deskcloseup.visible = false
	$Node2/Area2D/CollisionShape2D.disabled = true
	$Node2/Area2D.visible=false
	$Node/familyphoto/CollisionShape2D.disabled=true
	$Node/diary/CollisionPolygon2D.disabled=true
	get_tree().change_scene_to_file("res://assets/bedroompuzzle.tscn")
	


func _on_animation_player_3_animation_started(anim_name: StringName) -> void:
	pass # Replace with function body.
