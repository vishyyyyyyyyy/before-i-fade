extends Node2D

@onready var canvas = $CanvasModulate
@onready var narration_label: Label = $Label3
@onready var explore_node: Node2D = $explore 

var clicked_objects := {} 
var deskcounter:= 0

var segment_data := [
	{ "starts": [0.0, 2.0, 5.0], "ends": [1.0, 4.0, 7.0] }, 
	{ "starts": [0.0, 4.0, 8.0], "ends": [2.0, 6.0, 10.0] }
	
]
@onready var anim_players := [
	$CanvasLayer/AnimationPlayer2,
	$CanvasLayer/AnimationPlayer,
]
var anim_index := 0
var anim: AnimationPlayer
var dialogue_active := false
var segment_index := 0
var animating := true
var segment_starts
var segment_ends



func _ready():
	print("ready")
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
	
func _process(_delta):
	if not dialogue_active or not animating:
		return
	
	if anim.current_animation == "":
		return # No animation playing, skip

	if anim.get_current_animation_position() >= segment_ends[segment_index]:
		anim.pause()
		animating = false


func start_dialogue(index: int):
	# Safety
	if index >= anim_players.size():
		return

	# Stop all animations
	for a in anim_players:
		a.stop()

	anim_index = index
	anim = anim_players[anim_index]

	segment_starts = segment_data[anim_index].starts
	segment_ends   = segment_data[anim_index].ends

	segment_index = 0
	animating = true
	dialogue_active = true
	
	var anim_name := ""
	
	if anim_index == 0:
		if Global.character =="girlGhost":
			anim_name = "girlghost"

		elif Global.character =="boyGhost":
			anim_name ="boyghost"
		else:
			print("error animating text")
	
	if anim_index == 1:
		print("2nd anim6")
		$CanvasLayer/AnimationPlayer2/Label.visible=false
		$CanvasLayer/AnimationPlayer2/Label2.visible=false
		$CanvasLayer/AnimationPlayer2/Label3.visible=false
		$CanvasLayer/AnimationPlayer2/GirlGhost.visible=false
		$CanvasLayer/AnimationPlayer2/GirlGhost2.visible=false
		$CanvasLayer/AnimationPlayer2/BoyGhost.visible=false
		$CanvasLayer/AnimationPlayer2/BoyGhost2.visible=false
		$CanvasLayer/AnimationPlayer2/BoyGhost3.visible=false
		$CanvasLayer/AnimationPlayer2/skip.visible=false
		if Global.character =="girlGhost":
			anim_name = "friendtextGIRL"

		elif Global.character =="boyGhost":
			anim_name ="friendtextBOY"
		else:
			print("error animating text")
	
	anim.play(anim_name)     

func _input(event):
	if not dialogue_active:
		return

	if event.is_action_pressed("ui_accept") and not event.is_echo():
		textskip()	

func end_dialogue():
	dialogue_active = false
	anim.stop()

	print("Dialogue finished:", anim_index)
	if anim_index == 0:
		print("jjiiii")
		print("FIRST DIALOGUE FINISHED")
		$CanvasLayer/AnimationPlayer2/Label.visible=false
		$CanvasLayer/AnimationPlayer2/Label2.visible=false
		$CanvasLayer/AnimationPlayer2/Label3.visible=false
		$CanvasLayer/AnimationPlayer2/GirlGhost.visible=false
		$CanvasLayer/AnimationPlayer2/GirlGhost2.visible=false
		$CanvasLayer/AnimationPlayer2/BoyGhost.visible=false
		$CanvasLayer/AnimationPlayer2/BoyGhost2.visible=false
		$CanvasLayer/AnimationPlayer2/BoyGhost3.visible=false
		$CanvasLayer/AnimationPlayer2/skip.visible=false
		friendwalkin()
		
			
	if anim_index ==1:
		$CanvasLayer/AnimationPlayer/Label.visible=false
		$CanvasLayer/AnimationPlayer/Label2.visible=false
		$CanvasLayer/AnimationPlayer/Label3.visible=false
		$"CanvasLayer/AnimationPlayer/Friend label".visible=false
		$CanvasLayer/AnimationPlayer/YNlabel.visible=false
		$CanvasLayer/AnimationPlayer/Friend.visible=false
		$CanvasLayer/AnimationPlayer/Friend2.visible=false
		$CanvasLayer/AnimationPlayer/Girl.visible=false
		$CanvasLayer/AnimationPlayer/Girl2.visible=false
		$CanvasLayer/AnimationPlayer/Boy.visible=false
		$CanvasLayer/AnimationPlayer/Boy2.visible=false
		leaveroomandexplore()
		
		
	anim_index += 1


func textskip():
	if animating:
		anim.seek(segment_ends[segment_index], true)
		anim.pause()
		animating = false
	else:
		segment_index += 1 

		if segment_index < segment_starts.size():
			anim.seek(segment_starts[segment_index], true)
			anim.play()
			animating = true
		else:
			print("call end dialogue")
			end_dialogue()

	
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
		start_dialogue(0)
		dialogue_active = true
	
		
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
		start_dialogue(0)
		dialogue_active = true

#call after frien walks into room
func friendwalkin():
	$CanvasLayer/AnimationPlayer3/friend.visible = true
	await get_tree().create_timer(1.0).timeout

	if Global.character == "boyGhost":
		start_dialogue(1)  # anim and anim_index are set here
	elif Global.character == "girlGhost":
		start_dialogue(1)

func leaveroomandexplore():
	if Global.character == "boyGhost":
		await get_tree().create_timer(1.0).timeout
		$CanvasLayer/AnimationPlayer3/boyIdle.visible = false
		$CanvasLayer/AnimationPlayer3/boyWalk.visible = true
		$CanvasLayer/AnimationPlayer3.play("exit")
		await $CanvasLayer/AnimationPlayer3.animation_finished
		$Label3.visible=true
		unlock_explore()
	if Global.character == "girlGhost":
		await $CanvasLayer/AnimationPlayer.animation_finished
		await get_tree().create_timer(1.0).timeout
		$CanvasLayer/AnimationPlayer3/girlIdle.visible = false
		$CanvasLayer/AnimationPlayer3/girlWalk.visible = true
		$CanvasLayer/AnimationPlayer3.play("exitGirl")
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
					$Label3.visible=false
					$Node/AnimationPlayer.play("boyfamilyphoto")
					$Node/familyphoto/CollisionShape2D.disabled=true
					$Node/diary/CollisionPolygon2D.disabled=true
					await $Node/AnimationPlayer.animation_finished
					$Node/familyphoto/CollisionShape2D.disabled=false
					$Node/diary/CollisionPolygon2D.disabled=false
					$Label3.visible=true
					deskcounter +=1
					
				else:
					$Label3.visible=false
					$Node/AnimationPlayer.play("girlfamilyphoto")
					$Node/familyphoto/CollisionShape2D.disabled=true
					$Node/diary/CollisionPolygon2D.disabled=true
					await $Node/AnimationPlayer.animation_finished
					$Node/familyphoto/CollisionShape2D.disabled=false
					$Node/diary/CollisionPolygon2D.disabled=false
					$Label3.visible=true
					deskcounter +=1
			"diary":
				if Global.character == "boyGhost":
					$Label3.visible=false
					$Node/AnimationPlayer2.play("boydiarytext")
					$Node/familyphoto/CollisionShape2D.disabled=true
					$Node/diary/CollisionPolygon2D.disabled=true
					await $Node/AnimationPlayer2.animation_finished
					$Node/diary/CollisionPolygon2D.disabled=false
					$Node/familyphoto/CollisionShape2D.disabled=false
					$Label3.visible=true
					deskcounter +=1
				else:
					$Label3.visible=false
					$Node/AnimationPlayer2.play("girldiarytext")
					$Node/diary/CollisionPolygon2D.disabled=true
					$Node/familyphoto/CollisionShape2D.disabled=true
					await $Node/AnimationPlayer2.animation_finished
					$Node/diary/CollisionPolygon2D.disabled=false
					$Node/familyphoto/CollisionShape2D.disabled=false
					$Label3.visible=true
					deskcounter +=1
					
		if deskcounter >1:
			$Label3.visible=false
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
