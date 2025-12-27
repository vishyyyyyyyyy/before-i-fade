extends Area2D

var time_left_seconds
func _ready() -> void:
	# Assuming LineEdit is $LineEdit
	$"../continue".pressed.connect(pressed)
	$"../LineEdit".text = ""
	$"../LineEdit".editable = false 
	$"../LineEdit".connect("text_submitted", Callable(self, "_on_text_entered"))

func _process(delta: float) -> void:
	time_left_seconds = $"../Timer2".time_left
	$"../Label5".text = "%.1f" % time_left_seconds
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		$CollisionShape2D.disabled=true
		$"../Label".visible = false
		$"../Safecloseup".visible = true
		$"../TileMap3".visible = true
		if Global.character == "boyGhost":
			$"../ghosttext2".play("boy")
		if Global.character == "girlGhost":
			$"../ghosttext2".play("girl")
		await $"../ghosttext2".animation_finished
		if Global.character == "boyGhost":
			$"../fridgememory".play("boy")
		if Global.character == "girlGhost":
			$"../fridgememory".play("girl")
		await $"../fridgememory".animation_finished
		if Global.character == "boyGhost":
			$"../ghosttext3".play("boy")
		if Global.character == "girlGhost":
			$"../ghosttext3".play("girl")
		await $"../ghosttext3".animation_finished
		$"../ColorRect".visible = true
		$"../Menucard".visible = true
		$"../Label2".visible = true
		$"../Label3".visible = true
		$"../Label4".visible = true
		$"../continue".visible = true
		$"../continue/CollisionShape2D".disabled=false

func pressed():
	$"../Timer".visible = true
	$"../Label4".visible=false
	$"../Label5".visible = true
	$"../Label6".visible = true
	$"../LineEdit".editable = true
	$"../LineEdit".visible=true
	$"../LineEdit".grab_focus() 
	$"../Timer2".start()

func _on_text_entered(new_text: String) -> void:
	if new_text.strip_edges().to_lower() == "fade":
		print("Correct!")
		$"../LineEdit".visible=false
		$"../Timer2".stop()
		$"../Correct".visible=true
		$"../AudioStreamPlayer".play()
		$"../LineEdit".editable = false
		$"../Label6".visible=false
		$"../Timer".visible=false
		$"../Label5".visible=false
		await get_tree().create_timer(2).timeout
		$"../Correct".visible=false
		$"../Safecloseup".visible=false
		$"../Opensafe".visible=true
		if Global.character == "boyGhost":
			$"../ghosttext4".play("boy")
		if Global.character == "girlGhost":
			$"../ghosttext4".play("girl")
		await $"../ghosttext4".animation_finished
		$"../Opensafe".visible=false
		$"../Recordscreen".visible=true
		if Global.character == "boyGhost":
			$"../pastvideo".play("boy")
		if Global.character == "girlGhost":
			$"../pastvideo".play("girl")
		await $"../pastvideo".animation_finished
		$"../Recordscreen".visible=false
		$"../Opensafe".visible=true
		if Global.character == "boyGhost":
			$"../ghosttext5".play("boy")
		if Global.character == "girlGhost":
			$"../ghosttext5".play("girl")
		await $"../ghosttext5".animation_finished
		$"../TileMap3".visible=true
		$"../Opensafe".visible=false
		$"../Label7".visible=true
		$"../../SceneTrigger/CollisionShape2D".disabled=true
		

func _on_timer_2_timeout() -> void:
	print("Incorrect")
	$"../Timer2".stop()
	$"../Wrong".visible=true
	$"../AudioStreamPlayer2".play()
	await get_tree().create_timer(2).timeout
	reset()

func reset():
	$"../LineEdit".text = ""  
	$"../Wrong".visible=false
	$"../Timer2".start()
