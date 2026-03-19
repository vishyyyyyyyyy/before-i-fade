extends Node2D

var time_left_seconds
@onready var narration_label: Label = $CanvasLayer/Label
@onready var explore_node: Node = $explore

var clicked_objects := {} 
var piece_start_positions := {}


var segment_data := [
	{ "starts": [0.0, 4.0], "ends": [2.0, 6.0] }, #ghosttext1 
	{ "starts": [0.0, 4.0], "ends": [2.0, 6.0] }, #neighbor
	{ "starts": [0.0, 4.0, 10.0, 14.0], "ends": [2.0, 6.0, 12.0, 16.0] }, #ghosttext2
	{ "starts": [0.0, 4.0, 10.0, 16.0, 20.0], "ends": [2.0, 8.0, 14.0, 18.0, 24.0] }, #ghosttext3
	{ "starts": [0.0, 4.0, 8.0, 12.0], "ends": [2.0, 6.0, 10.0, 14.0] }, #ghosttext4
	{ "starts": [0.0], "ends": [2.0] } #bedroom fail 
]
@onready var anim_players := [
	$CanvasLayer/ghosttext1,
	$"CanvasLayer/neighbor talk",
	$CanvasLayer/ghosttext2,
	$CanvasLayer/ghosttext3,
	$CanvasLayer/ghosttext4,
	$CanvasLayer/hallwayfailghost
]
var anim_index := 0
var anim: AnimationPlayer
var dialogue_active := false
var segment_index := 0
var animating := true
var segment_starts
var segment_ends

@onready var  reset_timer = $Timer

signal dialogue_finished(index)

var hearts = 3
var repeat_lines = [
	'"I feel like I\'ve been here before..."',
	'"This place feels familiar."',
	'"Didn\'t I just do this?"',
	'"Why am I back here again?"',
	'"I swear I was just here."',
	'"Something isn\'t right..."'
]


func _ready():
	MusicManager.music_player.pitch_scale = 1.0
	reset_timer.timeout.connect(_on_reset_timeout)
	#Global.hallwayfail = true
	if Global.hallwayfail == true:
		$CanvasLayer/hallwayfailghost/Label.text  = repeat_lines.pick_random()
		fade_out_music()
		$CanvasLayer/failpuzzlecutscene/AnimationPlayer.play("text")
		await get_tree().create_timer(16).timeout
		fade_in_music()
		MusicManager.play_scene_music("menu")
		await start_dialogue(5)
	else:
		MusicManager.music_player.pitch_scale = 1.0
		MusicManager.play_scene_music("menu")
		
	if MusicManager.music_on:
		$CanvasPause/PauseMenu/music/Label.text = "Music: ON"
	else:
		$CanvasPause/PauseMenu/music/Label.text = "Music: OFF"
	$diarypage/diarycontinue.diarypagecontinue.connect(diarypagecontinue)
	$CanvasLayer/AnimationPlayer/neighbor.visible = false
	$CanvasLayer/AnimationPlayer/neighborRight.visible = false
	$CanvasLayer/AnimationPlayer/neighborLeft.visible = false
	$CanvasLayer/AnimationPlayer/neighborForward.visible = false
	$CanvasLayer/AnimationPlayer/neighborBackward.visible = false
	$CanvasLayer/AnimationPlayer/neighborLook.visible = false
	Global.reusabledesk = 2
	$CanvasLayer/Node3/continue.pressed.connect(_on_button_pressed)
	ghosttext1()
	#unlock_explore()
	for piece in $CanvasLayer/puzzle/pieces.get_children():
		piece_start_positions[piece] = piece.position
		piece.connect("piece_snapped", Callable(self, "_on_piece_snapped"))
#
func _process(delta: float) -> void:
	time_left_seconds = $CanvasLayer/Node3/Timer2.time_left
	$CanvasLayer/Node3/Label5.text = "%.1f" % time_left_seconds
	$CanvasLayer/Node3/Label5.add_theme_color_override("font_color", Color(0,0,0))
	
	if time_left_seconds < 11.0:
			if int(Time.get_ticks_msec() / 300) % 3 == 0:
				$CanvasLayer/Node3/Label5.add_theme_color_override("font_color", Color(1,0,0))
			else:
				$CanvasLayer/Node3/Label5.add_theme_color_override("font_color", Color(0,0,0))
				
	# --- music speed control ---
	if not $CanvasLayer/Node3/Timer2.is_stopped():
		var total_time = $CanvasLayer/Node3/Timer2.wait_time
		var t = time_left_seconds / total_time
		
		# start slow (0.75) → end normal (1.0)
		MusicManager.music_player.pitch_scale = lerp(1.0, 0.75, t)

	if not dialogue_active or not animating:
		return
	
	if anim.current_animation == "":
		return # No animation playing, skip

	if anim.get_current_animation_position() >= segment_ends[segment_index]:
		anim.pause()
		animating = false

func fade_out_music():
	var tween = create_tween()
	tween.tween_property(MusicManager.music_player, "volume_db", -40, 8.0)

func fade_in_music():
	var tween = create_tween()
	tween.tween_property(MusicManager.music_player, "volume_db", 0, 8.0)
	
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
		$CanvasLayer/hallwayfailghost/Label.visible=false
		$CanvasLayer/hallwayfailghost/GirlGhost.visible=false
		$CanvasLayer/hallwayfailghost/BoyGhost.visible=false
		$CanvasLayer/hallwayfailghost/skip.visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girltext"

		elif Global.character =="boyGhost":
			anim_name ="boytext"
		else:
			print("error animating text")
	
	if anim_index == 1:
		$CanvasLayer/hallwayfailghost/Label.visible=false
		$CanvasLayer/hallwayfailghost/GirlGhost.visible=false
		$CanvasLayer/hallwayfailghost/BoyGhost.visible=false
		$CanvasLayer/hallwayfailghost/skip.visible=false
		
		$CanvasLayer/ghosttext1/Label2.visible=false
		$CanvasLayer/ghosttext1/GirlGhost.visible=false
		$CanvasLayer/ghosttext2/BoyGhost2.visible=false
		$CanvasLayer/ghosttext1/BoyGhost.visible=false
		$CanvasLayer/ghosttext1/skip.visible=false
	
		anim_name = "neighbortext"
	
	if anim_index == 2:
		$CanvasLayer/hallwayfailghost/Label.visible=false
		$CanvasLayer/hallwayfailghost/GirlGhost.visible=false
		$CanvasLayer/hallwayfailghost/BoyGhost.visible=false
		$CanvasLayer/hallwayfailghost/skip.visible=false
		
		$CanvasLayer/ghosttext1/Label2.visible=false
		$CanvasLayer/ghosttext1/GirlGhost.visible=false
		$CanvasLayer/ghosttext2/BoyGhost2.visible=false
		$CanvasLayer/ghosttext1/BoyGhost.visible=false
		$CanvasLayer/ghosttext1/skip.visible=false
		
		$"CanvasLayer/neighbor talk/neighborlabel".visible=false
		$"CanvasLayer/neighbor talk/neighbor".visible=false
		$"CanvasLayer/neighbor talk/skip".visible=false
		$"CanvasLayer/neighbor talk/Label2".visible=false
		if Global.character =="girlGhost":
			anim_name = "girlghosttext"

		elif Global.character =="boyGhost":
			anim_name ="boyghosttext"
		else:
			print("error animating text")
	if anim_index == 3: 
		$CanvasLayer/hallwayfailghost/Label.visible=false
		$CanvasLayer/hallwayfailghost/GirlGhost.visible=false
		$CanvasLayer/hallwayfailghost/BoyGhost.visible=false
		$CanvasLayer/hallwayfailghost/skip.visible=false
		
		$"CanvasLayer/ghosttext2/Label4".visible=false
		$CanvasLayer/ghosttext2/BoyGhost.visible=false
		$CanvasLayer/ghosttext2/skip.visible=false
		$CanvasLayer/ghosttext2/GirlGhost.visible=false
		$CanvasLayer/ghosttext2/GirlGhost2.visible=false
		$CanvasLayer/ghosttext2/BoyGhost2.visible=false
		
		$CanvasLayer/ghosttext1/Label2.visible=false
		$CanvasLayer/ghosttext1/GirlGhost.visible=false
		$CanvasLayer/ghosttext2/BoyGhost2.visible=false
		$CanvasLayer/ghosttext1/BoyGhost.visible=false
		$CanvasLayer/ghosttext1/skip.visible=false
		
		$"CanvasLayer/neighbor talk/neighborlabel".visible=false
		$"CanvasLayer/neighbor talk/neighbor".visible=false
		$"CanvasLayer/neighbor talk/skip".visible=false
		$"CanvasLayer/neighbor talk/Label2".visible=false
		if Global.character =="girlGhost":
			anim_name = "girltext"

		elif Global.character =="boyGhost":
			anim_name ="boytext"
		else:
			print("error animating text")
		
	if anim_index == 4:
		$CanvasLayer/hallwayfailghost/Label.visible=false
		$CanvasLayer/hallwayfailghost/GirlGhost.visible=false
		$CanvasLayer/hallwayfailghost/BoyGhost.visible=false
		$CanvasLayer/hallwayfailghost/skip.visible=false
			
		$CanvasLayer/ghosttext3/Label5.visible=false
		$CanvasLayer/ghosttext3/BoyGhost.visible=false
		$CanvasLayer/ghosttext3/GirlGhost.visible=false
		$CanvasLayer/ghosttext3/skip.visible=false
		
		$"CanvasLayer/ghosttext2/Label4".visible=false
		$CanvasLayer/ghosttext2/BoyGhost.visible=false
		$CanvasLayer/ghosttext2/skip.visible=false
		$CanvasLayer/ghosttext2/GirlGhost.visible=false
		$CanvasLayer/ghosttext2/GirlGhost2.visible=false
		$CanvasLayer/ghosttext2/BoyGhost2.visible=false
		
		$CanvasLayer/ghosttext1/Label2.visible=false
		$CanvasLayer/ghosttext1/GirlGhost.visible=false
		$CanvasLayer/ghosttext2/BoyGhost2.visible=false
		$CanvasLayer/ghosttext1/BoyGhost.visible=false
		$CanvasLayer/ghosttext1/skip.visible=false
		
		$"CanvasLayer/neighbor talk/neighborlabel".visible=false
		$"CanvasLayer/neighbor talk/neighbor".visible=false
		$"CanvasLayer/neighbor talk/skip".visible=false
		$"CanvasLayer/neighbor talk/Label2".visible=false
		
		if Global.character =="girlGhost":
			anim_name = "girl"

		elif Global.character =="boyGhost":
			anim_name ="boy"
		else:
			print("error animating text")
		
	if anim_index == 5: 
		if Global.character =="girlGhost":
			anim_name = "repeatgirl"

		elif Global.character =="boyGhost":
			anim_name ="repeatboy"
		else:
			print("error animating text")		
		
	anim.play(anim_name) 
	   
	await dialogue_finished 

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
		$CanvasLayer/ghosttext1/Label2.visible=false
		$CanvasLayer/ghosttext1/GirlGhost.visible=false
		$CanvasLayer/ghosttext2/BoyGhost2.visible=false
		$CanvasLayer/ghosttext1/BoyGhost.visible=false
		$CanvasLayer/ghosttext1/skip.visible=false
			
	if anim_index ==1:
		$"CanvasLayer/neighbor talk/neighborlabel".visible=false
		$"CanvasLayer/neighbor talk/neighbor".visible=false
		$"CanvasLayer/neighbor talk/skip".visible=false
		$"CanvasLayer/neighbor talk/Label2".visible=false
	
	if anim_index == 2:
		$"CanvasLayer/ghosttext2/Label4".visible=false
		$CanvasLayer/ghosttext2/BoyGhost.visible=false
		$CanvasLayer/ghosttext2/skip.visible=false
		$CanvasLayer/ghosttext2/GirlGhost.visible=false
		$CanvasLayer/ghosttext2/GirlGhost2.visible=false
		$CanvasLayer/ghosttext2/BoyGhost2.visible=false
		
		
	if anim_index == 3:	
		$CanvasLayer/ghosttext3/Label5.visible=false
		$CanvasLayer/ghosttext3/BoyGhost.visible=false
		$CanvasLayer/ghosttext3/GirlGhost.visible=false
		$CanvasLayer/ghosttext3/skip.visible=false
	
	if anim_index == 4:
		$CanvasLayer/ghosttext4/Label4.visible=false
		$CanvasLayer/ghosttext4/GirlGhost.visible=false
		$CanvasLayer/ghosttext4/BoyGhost.visible=false
		$CanvasLayer/ghosttext4/skip.visible=false
		
	if anim_index == 5:
		$CanvasLayer/hallwayfailghost/Label.visible=false
		$CanvasLayer/hallwayfailghost/GirlGhost.visible=false
		$CanvasLayer/hallwayfailghost/BoyGhost.visible=false
		$CanvasLayer/hallwayfailghost/skip.visible=false
		
	emit_signal("dialogue_finished", anim_index)



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


func ghosttext1():
	await start_dialogue(0)
	modulate()
		#
func modulate():
	$CanvasLayer/Camera2D.shake(2, 1.4)
	if Global.character == "girlGhost":
		$CanvasLayer/AnimationPlayer/neighbor.visible=true
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
		$CanvasLayer/AnimationPlayer/neighbor.visible = true
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/AnimationPlayer/neighbor.visible=false
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
		$CanvasLayer/AnimationPlayer/neighbor.visible = false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer/AnimationPlayer/neighbor.visible=true
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
		$CanvasLayer/AnimationPlayer/neighbor.visible = true
		print("hi1")
		await get_tree().create_timer(1).timeout
		print("h2")
		await start_dialogue(1)
		$CanvasLayer/AnimationPlayer/neighbor.visible = false
		$CanvasLayer/AnimationPlayer.play("neighborPhotos")
		await $CanvasLayer/AnimationPlayer.animation_finished
		await start_dialogue(2)
		$CanvasLayer/Label.visible=true
		$explore/CanvasLayer/flowers/CollisionShape2D.disabled=false
		$explore/CanvasLayer/flowers/CollisionShape2D2.disabled=false
		$explore/CanvasLayer/lamp/CollisionShape2D.disabled=false
		$explore/CanvasLayer/photos/CollisionShape2D.disabled=false
		unlock_explore()
		
	if Global.character == "boyGhost":
		$CanvasLayer/AnimationPlayer/neighbor.visible=true
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
		$CanvasLayer/AnimationPlayer/neighbor.visible=false
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
		$CanvasLayer/AnimationPlayer/neighbor.visible=true
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
		await start_dialogue(1)
		$CanvasLayer/AnimationPlayer/neighbor.visible = false
		$CanvasLayer/AnimationPlayer.play("neighborPhotos")
		await $CanvasLayer/AnimationPlayer.animation_finished
		await start_dialogue(2)
		$CanvasLayer/Label.visible=true
		$explore/CanvasLayer/flowers/CollisionShape2D.disabled=false
		$explore/CanvasLayer/flowers/CollisionShape2D2.disabled=false
		$explore/CanvasLayer/lamp/CollisionShape2D.disabled=false
		$explore/CanvasLayer/photos/CollisionShape2D.disabled=false
		unlock_explore()
#
func unlock_explore():
	$CanvasLayer/Label.visible = true
	
	var areas = {
		"photos": $explore/CanvasLayer/photos,
		"lamp": $explore/CanvasLayer/lamp,
		"flowers": $explore/CanvasLayer/flowers
	}

	for name in areas:
		var area_node = areas[name]

		if area_node is Area2D:
			area_node.clicked.connect(
				func(text):
					_on_object_clicked(text, name)
			)
		
var is_interacting = false
	
func _on_object_clicked(text: String, area_name: String):
# Immediately update label for any object
	narration_label.text = text
	narration_label.visible = true

	# Mark this object as clicked
	if not clicked_objects.has(area_name):
		clicked_objects[area_name] = true

	# If box clicked but not all others, show message and skip sequence
	if area_name == "photos" and not all_non_photos_clicked():
		narration_label.text = "Let's finish looking at everything else first."
		narration_label.visible = true
		reset_timer.start() 
		return
		
		
	## If desk clicked after everything else, trigger scene change
	if area_name == "photos" and all_non_photos_clicked():
		narration_label.visible=false
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
			await start_dialogue(3)
			$CanvasLayer/TileMap3.visible=false
			$CanvasLayer/Auntframe.visible=false
			$CanvasLayer/Boyframe.visible=false
			$CanvasLayer/Friendframe.visible=false
			$CanvasLayer/Neigborframe.visible=false
			hallwaypuzzle()
			return
		if Global.character == "boyGhost":
			$CanvasLayer/TileMap3.visible=true
			$CanvasLayer/Auntframe.visible=true
			$CanvasLayer/Friendframe.visible=true
			$CanvasLayer/Girlframe.visible=true
			$CanvasLayer/Neigborframe.visible=true
			await start_dialogue(3)
			$CanvasLayer/TileMap3.visible=false
			$CanvasLayer/Auntframe.visible=false
			$CanvasLayer/Friendframe.visible=false
			$CanvasLayer/Girlframe.visible=false
			$CanvasLayer/Neigborframe.visible=false
			hallwaypuzzle()
			return
	reset_timer.start()
	
func _on_reset_timeout():
	if not is_interacting:
		narration_label.text = 'Investigate the hallway by pressing "E" to interact with objects.'
		
func all_non_photos_clicked() -> bool:
	var non_desk = ["lamp", "flowers"]
	for name in non_desk:
		if not clicked_objects.has(name): 
			return false
	return true
#
func _on_button_pressed():
	MusicManager.play_scene_music("puzzle2")
	MusicManager.music_player.pitch_scale = 0.75
	$CanvasLayer/Node3/Timer2.start()
	$CanvasLayer/Node3/Timer.visible=true
	$CanvasLayer/Node3/Label5.visible=true
	$CanvasLayer/puzzle.visible=true
	$CanvasLayer/Label8.visible=true
	if hearts == 3:
			$CanvasLayer/Node3/Heart.visible=true
			$CanvasLayer/Node3/Heart2.visible=true
			$CanvasLayer/Node3/Heart3.visible=true
	if hearts == 2:
			$CanvasLayer/Node3/Heart.visible=true
			$CanvasLayer/Node3/Heart2.visible=true
	if hearts == 1:
			$CanvasLayer/Node3/Heart.visible=true
			
	if Global.character== "girlGhost":
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=true
		$CanvasLayer3/CanvasModulate/Boyframe5.visible=true
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=true
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=true
	if Global.character== "boyGhost":
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=true
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=true
		$CanvasLayer3/CanvasModulate/Girlframe5.visible=true
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=true
		$CanvasLayer/puzzle/pieces/piece13.texture = load("res://assets/hallwayPuzzlePics/girlframeTopLeft.png")
		$CanvasLayer/puzzle/pieces/piece14.texture = load("res://assets/hallwayPuzzlePics/girlframeTopRight.png")
		$CanvasLayer/puzzle/pieces/piece15.texture = load("res://assets/hallwayPuzzlePics/girlframeBottomLeft.png")
		$CanvasLayer/puzzle/pieces/piece16.texture = load("res://assets/hallwayPuzzlePics/girlframeBottomRight.png")
		
func hallwaypuzzle():
	$CanvasLayer3/CanvasModulate.color = Color(0.0, 0.992, 0.816)
	$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.322, 0.278)
	$CanvasLayer3/CanvasModulate/Auntframe5.visible=false
	$CanvasLayer3/CanvasModulate/Boyframe5.visible=false
	$CanvasLayer3/CanvasModulate/Friendframe5.visible=false
	$CanvasLayer3/CanvasModulate/Girlframe5.visible=false
	$CanvasLayer3/CanvasModulate/Neigborframe5.visible=false
	$CanvasLayer3/CanvasModulate/Picturepiece.visible=true
	$CanvasLayer3/CanvasModulate/Picturepiece2.visible=true
	$CanvasLayer3/CanvasModulate/Picturepiece3.visible=true
	$CanvasLayer3/CanvasModulate/Picturepiece4.visible=true
	$CanvasLayer/Node3/Timer.visible=false
	$CanvasLayer/Node3/Label5.visible=false
	await get_tree().create_timer(2).timeout
	$CanvasLayer/Node3/ColorRect.visible=true
	$CanvasLayer/Node3/Menucard.visible=true
	$CanvasLayer/Node3/Label2.visible=true
	$CanvasLayer/Node3/Label.visible=true
	$CanvasLayer/Node3/Label3.visible=true
	$CanvasLayer/Node3/continue.visible=true
	$CanvasLayer/Node3/continue/CollisionShape2D.disabled=false
	$CanvasLayer/AnimationPlayer/neighborRight.visible=false
	$CanvasLayer/AnimationPlayer/neighborLeft.visible=false
	$CanvasLayer/AnimationPlayer/neighborForward.visible=false
	$CanvasLayer/AnimationPlayer/neighborBackward.visible=false
	$CanvasLayer/AnimationPlayer/neighborLook.visible=false
	$CanvasLayer/Node3/ColorRect.visible=true
func check_picture_complete(picture_id: int) -> bool:
	for slot in $CanvasLayer/puzzle/slots.get_children():
		if slot.picture_id == picture_id and not slot.occupied:
			return false
	return true

func _on_piece_snapped():
	for picture_id in range(4):
		if check_picture_complete(picture_id):
			print("Picture", picture_id, "complete!")
		if (check_picture_complete(0) && check_picture_complete(1) && check_picture_complete(2) && check_picture_complete(3)):
			print("puzzle complete!")
			Global.hallwayfail = false
			$CanvasLayer/Node3/Timer2.stop()
			$CanvasLayer/Node3/Correct.visible=true
			$CanvasLayer/Node3/AudioStreamPlayer.play()
			afterpuzzle()
			
			
func _on_timer_2_timeout():
	MusicManager.music_player.pitch_scale = 1.0
	MusicManager.play_scene_music("menu")
	$CanvasLayer/Node3/Wrong.visible=true
	$CanvasLayer/Node3/AudioStreamPlayer2.play()
	$CanvasLayer/Node3/Timer2.stop()
	hearts -= 1
	if hearts  ==2:
		$CanvasLayer/Node3/Heart3.visible=false
		$CanvasLayer/Node3/Heart6.visible=true
		
	elif hearts  ==1:
		$CanvasLayer/Node3/Heart2.visible=false
		$CanvasLayer/Node3/Heart5.visible=true

	elif hearts <= 0:
		$CanvasLayer/Node3/Heart.visible=false
		$CanvasLayer/Node3/Heart4.visible=true
		Global.hallwayfail = true
		$CanvasLayer/Node3/Timer2.stop() 
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://scenes/hallway.tscn")
		return
	
	else:
		return
	await get_tree().create_timer(2).timeout
	$CanvasLayer/Node3/Wrong.visible=false
	$CanvasLayer/Node3/Label5.add_theme_color_override("font_color", Color(0,0,0))
	$CanvasLayer/Node3/Timer2.start()
	resetpuzzle()

func resetpuzzle():
	# Reset pieces
	for piece in piece_start_positions.keys():
		piece.position = piece_start_positions[piece]
		if piece.has_method("reset"):
			piece.reset()

	# Reset slots
	for slot in $CanvasLayer/puzzle/slots.get_children():
		if slot.has_method("reset"):
			slot.reset()

	print("Puzzle reset")

	
func afterpuzzle():
	MusicManager.music_player.pitch_scale = 1.0
	MusicManager.play_scene_music("menu")
	$CanvasLayer3/CanvasModulate/Picturepiece.visible=false
	$CanvasLayer3/CanvasModulate/Picturepiece2.visible=false
	$CanvasLayer3/CanvasModulate/Picturepiece3.visible=false
	$CanvasLayer3/CanvasModulate/Picturepiece4.visible=false
	$CanvasLayer/Label8.visible=false
	await get_tree().create_timer(2).timeout
	$CanvasLayer/Node3/Timer.visible=false
	$CanvasLayer/Node3/Heart.visible=false
	$CanvasLayer/Node3/Heart2.visible=false
	$CanvasLayer/Node3/Heart3.visible=false
	$CanvasLayer/Node3/Heart4.visible=false
	$CanvasLayer/Node3/Heart5.visible=false
	$CanvasLayer/Node3/Heart6.visible=false
	$CanvasLayer/Node3/Label5.visible=false
	$CanvasLayer/Node3/Correct.visible=false
	$CanvasLayer/puzzle.visible=false
	$diarypage.visible=true
	$diarypage/diarycontinue/CollisionShape2D.disabled=false
	
	
func diarypagecontinue():
	$diarypage.visible=false
	$diarypage/diarycontinue/CollisionShape2D.disabled=true
	$CanvasLayer/TileMap3.visible=true
	$CanvasLayer/Auntframe.visible=true
	$CanvasLayer/Friendframe.visible=true
	$CanvasLayer/Neigborframe.visible=true
	$CanvasLayer/TileMap3.visible=true
	$CanvasLayer/TileMap3.modulate=Color(0.0, 0.992, 0.816)
	$CanvasLayer/Auntframe.modulate=Color(0.0, 0.992, 0.816)
	$CanvasLayer/Boyframe.modulate=Color(0.0, 0.992, 0.816)
	$CanvasLayer/Friendframe.modulate=Color(0.0, 0.992, 0.816)
	$CanvasLayer/Girlframe.modulate=Color(0.0, 0.992, 0.816)
	$CanvasLayer/Neigborframe.modulate=Color(0.0, 0.992, 0.816)
	$CanvasLayer/Neighbornote3.visible=true
	if Global.character == "girlGhost":
		$CanvasLayer/Boyframe.visible=true
		await start_dialogue(4)
	elif Global.character == "boyGhost":
		$CanvasLayer/Girlframe.visible=true
		await start_dialogue(4)
		 
	$CanvasLayer/blobGhostPlayer.position.x = 1166
	$CanvasLayer/blobGhostPlayer.position.y = 520
	$CanvasLayer/Neighbornote3.visible=false
	$CanvasLayer/TileMap3.visible=false
	$CanvasLayer/Auntframe.visible=false
	$CanvasLayer/Friendframe.visible=false
	$CanvasLayer/Neigborframe.visible=false
	$CanvasLayer/TileMap3.visible=false
	$CanvasLayer/Boyframe.visible=false
	$CanvasLayer/Girlframe.visible=false
	$CanvasLayer/scenetrigger/CollisionShape2D.disabled=false
	$CanvasLayer/Node2D/arrow.play("arrow")
	$CanvasLayer/Label7.visible=true
