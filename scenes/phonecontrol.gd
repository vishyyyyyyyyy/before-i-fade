extends Area2D

var counter = 0
var phonecode =""
signal challengecompleted

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:

		if counter == 0:
			if shape_idx == 0 :
				$"../phonemusic".visible=true
				await get_tree().create_timer(1).timeout
				incorrect1()

			elif shape_idx == 1:
				$"../recphone".visible=true
				await get_tree().create_timer(1).timeout
				incorrect1()
				
			elif shape_idx == 2:
				$"../phonenotes".visible = true
				await get_tree().create_timer(1).timeout
				incorrect1()
				
			elif shape_idx == 3:
				$"../phonecalc".visible = true
				await get_tree().create_timer(1).timeout
				incorrect1()
				
			elif shape_idx == 4:
				$CollisionShape2D.disabled= true
				$CollisionShape2D2.disabled=true
				$CollisionShape2D3.disabled= true
				$CollisionShape2D4.disabled= true
				$CollisionShape2D5.disabled= true
				$CollisionShape2D6.disabled = true
				$"../phonephone".visible = true
				$"1".disabled=false
				$"2".disabled=false
				$"3".disabled=false
				$"4".disabled =false
				$"5".disabled= false
				$"6".disabled = false
				$"7".disabled = false
				$"8".disabled=false
				$"9".disabled = false
				$"0".disabled=false
				$check.disabled=false
				$delete.disabled=false
				counter = 1
				
			elif shape_idx == 5:
				$"../phonemail".visible = true
				await get_tree().create_timer(1).timeout
				incorrect1()
				
		if counter == 1:
			$CollisionShape2D.disabled= true
			$CollisionShape2D2.disabled=true
			$CollisionShape2D3.disabled= true
			$CollisionShape2D4.disabled= true
			$CollisionShape2D5.disabled= true
			$CollisionShape2D6.disabled = true
			if shape_idx == 6:
				phonecode += "1"
				$"../phonetext".text = phonecode
				print(phonecode)
			if shape_idx == 7:
				phonecode += "2"
				$"../phonetext".text = phonecode
				print(phonecode)
			if shape_idx == 8:
				phonecode += "3"
				$"../phonetext".text = phonecode
			if shape_idx == 9:
				phonecode += "4"
				$"../phonetext".text = phonecode
			if shape_idx == 10:
				phonecode += "5"
				$"../phonetext".text = phonecode
			if shape_idx ==11:
				phonecode += "6"
				$"../phonetext".text = phonecode
			if shape_idx == 12:
				phonecode += "7"
				$"../phonetext".text = phonecode
			if shape_idx == 13:
				phonecode += "8"
				$"../phonetext".text = phonecode
			if shape_idx == 14:
				phonecode += "9"
				$"../phonetext".text = phonecode
			if shape_idx == 15:
				phonecode += "0"
				$"../phonetext".text = phonecode
				
		if shape_idx == 16 and phonecode == "911":
				print("yay")
				counter = 2
				$"../phonephone".visible=false
		if shape_idx == 17:
				phonecode = "" 
				$"../phonetext".text = phonecode
		print(phonecode)
			
		if counter == 2:
			$"../phonetext".visible=false	
			$CollisionShape2D.disabled= false
			$CollisionShape2D2.disabled=false
			$CollisionShape2D3.disabled= false
			$CollisionShape2D4.disabled= false
			$CollisionShape2D5.disabled= false
			$CollisionShape2D6.disabled = false
			$"1".disabled=true
			$"2".disabled=true
			$"3".disabled=true
			$"4".disabled =true
			$"5".disabled= true
			$"6".disabled = true
			$"7".disabled = true
			$"8".disabled=true
			$"9".disabled = true
			$"0".disabled=true
			$check.disabled=true
			$delete.disabled=true
			
			if shape_idx == 0 :
				$"../phonemusic".visible=true
				await get_tree().create_timer(1).timeout
				incorrect2()

			elif shape_idx == 1:
				correct()
				
			elif shape_idx == 2:
				$"../phonenotes".visible = true
				await get_tree().create_timer(1).timeout
				incorrect2()
				
			elif shape_idx == 3:
				$"../phonecalc".visible = true
				await get_tree().create_timer(1).timeout
				incorrect2()
				
			elif shape_idx == 4:
				$"../phonephone".visible = true
				await get_tree().create_timer(1).timeout
				incorrect2()
				
				
			elif shape_idx == 5:
				$"../phonemail".visible = true
				await get_tree().create_timer(1).timeout
				incorrect2()
			
			
func correct():
	$CollisionShape2D.disabled= true
	$CollisionShape2D2.disabled=true
	$CollisionShape2D3.disabled= true
	$CollisionShape2D4.disabled= true
	$CollisionShape2D5.disabled= true
	$CollisionShape2D6.disabled = true
	$"../Correct".visible=true
	$"../AudioStreamPlayer".play() 
	$"../Timer2".stop()
	$"../AnimationPlayer2/phone instructions".visible=false
	await get_tree().create_timer(2).timeout
	$"../AnimationPlayer2/unlockphone".visible=false
	$"../Correct".visible = false
	emit_signal("challengecompleted")


func incorrect1():
	$"../Wrong".visible=true
	$"../AudioStreamPlayer2".play()
	counter = 0
	await get_tree().create_timer(2).timeout
	$"../Wrong".visible=false
	$"../phonemusic".visible=false
	$"../recphone".visible=false
	$"../phonenotes".visible=false
	$"../phonecalc".visible=false
	$"../phonephone".visible=false
	$"../phonemail".visible=false
	

func incorrect2():
	$"../Wrong".visible=true
	$"../AudioStreamPlayer2".play()
	counter = 0
	await get_tree().create_timer(2).timeout
	$"../Wrong".visible=false
	$"../phonemusic".visible=false
	$"../recphone".visible=false
	$"../phonenotes".visible=false
	$"../phonecalc".visible=false
	$"../phonephone".visible=false
	$"../phonemail".visible=false
	$CollisionShape2D.disabled= false
	$CollisionShape2D2.disabled=false
	$CollisionShape2D3.disabled= false
	$CollisionShape2D4.disabled= false
	$CollisionShape2D5.disabled= false
	$CollisionShape2D6.disabled = false
	

func _on_timer_2_timeout() -> void:
	$"../phonemusic".visible=false
	$"../recphone".visible=false
	$"../phonenotes".visible=false
	$"../phonecalc".visible=false
	$"../phonephone".visible=false
	$"../phonemail".visible=false
	$"../Wrong".visible=true
	$"../AudioStreamPlayer2".play()
	counter = 0
	await get_tree().create_timer(2).timeout
	$"../Timer2".start()
