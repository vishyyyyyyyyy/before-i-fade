extends Area2D
@onready var spoon = $"../Spoon"
var counter := 0
var wrongcounter := 0
var stirring := false
var stir_stage := 0
var stir_timer := 0.0

var hearts = 3


signal challengecompleted

func _ready() -> void:
	input_pickable = true
	print("Area2D ready")
	$CollisionShape2D4.disabled=false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:

		if counter == 0:
			$"../Label".visible=true
			if shape_idx == 0 or shape_idx == 1:
				print("Stage 0: shape 0 or 1")
				$"../Kitchen10".visible = true
				wrongcounter +=1

			elif shape_idx == 2:
				print("Stage 0: shape 2")
				$"../Kitchen1".visible = true

			counter += 1
			
			$"../Flour".visible = false
			$"../Radish".visible = false
			$"../Strawberry".visible = false
			$"../Sugar".visible = true
			$"../Brocoli".visible = true
			$"../Avocado".visible = true

		elif counter == 1:
			if wrongcounter == 0:
				if shape_idx == 1:
					$"../Kitchen21".visible = true
				elif shape_idx == 2 or shape_idx ==0:
					$"../Kitchen11".visible = true
					wrongcounter +=1
				
			elif wrongcounter ==1:
				if shape_idx == 1:
					$"../Kitchen11".visible = true
					
				elif shape_idx == 2 or shape_idx ==0:
					$"../Kitchen11".visible = true
					wrongcounter +=1
			counter += 1
			$"../Sugar".visible = false
			$"../Brocoli".visible = false
			$"../Avocado".visible = false
			$"../Butter".visible=true
			$"../Orange".visible=true
			$"../Carrot".visible=true
			
		elif counter == 2:
			if wrongcounter == 0:
				if shape_idx == 0:
					$"../Kitchen2".visible = true
					
				elif shape_idx == 2 or shape_idx ==1:
					$"../Kitchen13".visible = true
					wrongcounter +=1
			else:
				$"../Kitchen13".visible=true
				
			counter += 1
			$"../Butter".visible=false
			$"../Orange".visible=false
			$"../Carrot".visible=false
			$"../Egg".visible=true
			
		elif counter == 3:
			$CollisionShape2D.disabled=true
			$CollisionShape2D3.disabled=true
			$"../Egg2".visible=true
			counter +=1
			
		elif counter == 4:
			$"../Egg3".visible=true
			counter +=1
			
		elif counter == 4:
			$"../Egg4".visible=true
			counter +=1
			
		elif counter == 5:
			$"../Egg5".visible=true
			counter +=1
		
		elif counter == 6:
			$"../Egg5".visible=false
			$"../Egg4".visible=false
			$"../Egg3".visible=false
			$"../Egg2".visible=false
			$"../Egg".visible=false
			$"../Egg6".visible=true
			$CollisionShape2D2.disabled=true
			await get_tree().create_timer(0.5).timeout
			$"../ColorRect3".visible=false
			$"../Egg6".visible=false
			if wrongcounter ==0:
				$"../Kitchen3".visible=true
			counter +=1
			start_stirring()
			
		elif counter ==7:
			if shape_idx == 3:
				if wrongcounter ==0:
					$"../Kitchen9".visible=true
					correct()
				else:
					$"../Kitchen19".visible=true
					incorrect()
				$CollisionShape2D4.disabled=true
				
			
func start_stirring():
	stirring = true
	stir_stage = 0
	stir_timer = 0.0

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	spoon.visible = true


func _process(delta):
	if stirring:
		spoon.position = get_viewport().get_mouse_position()
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			stir_timer += delta
			if stir_timer >= 0.6:
				stir_timer = 0
				advance_stir()



func advance_stir():
	stir_stage += 1

	match stir_stage:
		1:
			if wrongcounter == 0:
				$"../Kitchen4".visible = true
			else:
				$"../Kitchen14".visible=true
		2:
			if wrongcounter == 0:
				$"../Kitchen5".visible = true
			else:
				$"../Kitchen15".visible=true
		3:
			if wrongcounter == 0:
				$"../Kitchen6".visible = true
			else:
				$"../Kitchen16".visible=true
		4:
			if wrongcounter == 0:
				$"../Kitchen7".visible = true
			else:
				$"../Kitchen18".visible=true
			end_stirring()
func end_stirring():
	stirring = false
	$CollisionShape2D4.disabled=false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	spoon.visible = false



func _on_timer_2_timeout() -> void:
	end_stirring()
	$"../Sugar".visible = false
	$"../Brocoli".visible = false
	$"../Avocado".visible = false
	$"../Flour".visible = true
	$"../Radish".visible = true
	$"../Strawberry".visible = true
	$"../Butter".visible=false
	$"../Orange".visible=false
	$"../Carrot".visible=false
	$"../Egg5".visible=false
	$"../Egg4".visible=false
	$"../Egg3".visible=false
	$"../Egg2".visible=false
	$"../Egg".visible=false
	$"../Egg6".visible=false
	$"../Kitchen10".visible = false
	$"../Kitchen1".visible = false
	$"../Kitchen21".visible = false
	$"../Kitchen2".visible = false
	$"../Kitchen3".visible = false
	$"../Kitchen4".visible = false
	$"../Kitchen5".visible = false
	$"../Kitchen6".visible = false
	$"../Kitchen7".visible = false
	$"../Kitchen9".visible = false
	$"../Kitchen10".visible = false
	$"../Kitchen11".visible = false
	$"../Kitchen12".visible = false
	$"../Kitchen13".visible = false
	$"../Kitchen14".visible = false
	$"../Kitchen15".visible = false
	$"../Kitchen16".visible = false
	$"../Kitchen17".visible = false
	$"../Kitchen18".visible = false
	$"../Kitchen19".visible = false

	$CollisionShape2D.disabled=true
	$CollisionShape2D3.disabled=true
	$CollisionShape2D2.disabled=true
	$CollisionShape2D4.disabled=true
	$"../Node3/Wrong".visible=true
	
	hearts -= 1
	if hearts  ==2:
		$"../Node3/Heart3".visible=false
		$"../Node3/Heart6".visible=true
		
	elif hearts  ==1:
		$"../Node3/Heart2".visible=false
		$"../Node3/Heart5".visible=true

	elif hearts <= 0:
		$"../Node3/Heart".visible=false
		$"../Node3/Heart4".visible=true
		Global.kitchenfail = true
		$"../Node3/Timer2".stop()
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://scenes/kitchen.tscn")
		return
	else:
		return
		
	$"../Node3/AudioStreamPlayer2".play()
	await get_tree().create_timer(2).timeout
	$"../Node3/Label5".add_theme_color_override("font_color", Color(0,0,0))
	$"../Node3/Wrong".visible=false
	$CollisionShape2D.disabled=false
	$CollisionShape2D3.disabled=false
	$CollisionShape2D2.disabled=false
	counter =0
	wrongcounter =0
	$"../Node3/Timer2".start()


func correct():
	$"../Node3/Correct".visible = true
	$"../Kitchen10".visible = false
	$"../Kitchen1".visible = false
	$"../Kitchen21".visible = false
	$"../Kitchen2".visible = false
	$"../Kitchen3".visible = false
	$"../Kitchen4".visible = false
	$"../Kitchen5".visible = false
	$"../Kitchen6".visible = false
	$"../Kitchen7".visible = false
	$"../Kitchen10".visible = false
	$"../Kitchen11".visible = false
	$"../Kitchen12".visible = false
	$"../Kitchen13".visible = false
	$"../Kitchen14".visible = false
	$"../Kitchen15".visible = false
	$"../Kitchen16".visible = false
	$"../Kitchen17".visible = false
	$"../Kitchen18".visible = false
	$"../Kitchen19".visible = false
	$CollisionShape2D.disabled=true
	$CollisionShape2D3.disabled=true
	$CollisionShape2D2.disabled=true
	$CollisionShape2D4.disabled=true
	$"../Node3/AudioStreamPlayer".play() 
	$"../Node3/Timer2".stop()
	await get_tree().create_timer(2).timeout
	$"../Node3/Heart".visible=false
	$"../Node3/Heart2".visible=false 
	$"../Node3/Heart3".visible=false
	$"../Node3/Heart4".visible=false
	$"../Node3/Heart5".visible=false
	$"../Node3/Heart6".visible=false
	$"../Node3/Correct".visible = false
	emit_signal("challengecompleted")


func incorrect():
	end_stirring()
	$"../Node3/Wrong".visible=true
	$"../Node3/AudioStreamPlayer2".play()
	hearts -= 1
	if hearts  ==2:
		$"../Node3/Heart3".visible=false
		$"../Node3/Heart6".visible=true
		
	elif hearts  ==1:
		$"../Node3/Heart2".visible=false
		$"../Node3/Heart5".visible=true

	elif hearts <= 0:
		$"../Node3/Heart".visible=false
		$"../Node3/Heart4".visible=true
		Global.kitchenfail = true
		$"../Node3/Timer2".stop()
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://scenes/kitchen.tscn")
		return
	else:
		return
		
	await get_tree().create_timer(2).timeout
	$"../Sugar".visible = false
	$"../Brocoli".visible = false
	$"../Avocado".visible = false
	$"../Flour".visible = true
	$"../Radish".visible = true
	$"../Strawberry".visible = true
	$"../Butter".visible=false
	$"../Orange".visible=false
	$"../Carrot".visible=false
	$"../Egg5".visible=false
	$"../Egg4".visible=false
	$"../Egg3".visible=false
	$"../Egg2".visible=false
	$"../Egg".visible=false
	$"../Egg6".visible=false
	$"../Kitchen10".visible = false
	$"../Kitchen1".visible = false
	$"../Kitchen21".visible = false
	$"../Kitchen2".visible = false
	$"../Kitchen3".visible = false
	$"../Kitchen4".visible = false
	$"../Kitchen5".visible = false
	$"../Kitchen6".visible = false
	$"../Kitchen7".visible = false
	$"../Kitchen9".visible = false
	$"../Kitchen10".visible = false
	$"../Kitchen11".visible = false
	$"../Kitchen12".visible = false
	$"../Kitchen13".visible = false
	$"../Kitchen14".visible = false
	$"../Kitchen15".visible = false
	$"../Kitchen16".visible = false
	$"../Kitchen17".visible = false
	$"../Kitchen18".visible = false
	$"../Kitchen19".visible = false

	$CollisionShape2D.disabled=true
	$CollisionShape2D3.disabled=true
	$CollisionShape2D2.disabled=true
	$CollisionShape2D4.disabled=true
	$"../Node3/Wrong".visible=false
	$CollisionShape2D.disabled=false
	$CollisionShape2D3.disabled=false
	$CollisionShape2D2.disabled=false
	counter =0
	wrongcounter =0
	$"../Node3/Timer2".start()

	
