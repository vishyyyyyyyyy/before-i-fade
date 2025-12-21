extends Node2D

var code = ""
var count = 0
var time_left_seconds

func _ready():
	$Node3/Label2.visible=true
	$Node3/Label.visible=true
	$Node3/Label3.visible=true
	$Node3/Menucard.visible=true
	$Node3/ColorRect.visible=true
	$Node3/continue.visible=true
	$Node3/continue.pressed.connect(_on_continue_pressed)



func _on_continue_pressed():
	print("Node was clicked!")
	$AnimationPlayer.play("text")
	$Node3/continue/CollisionShape2D.disabled=true
	$Timer2.start()
	$desk.clicked.connect(_on_desk_clicked)
	
	
func _on_desk_clicked():
	print("Clicked from main script!")

func _process(delta: float) -> void:
	time_left_seconds = $Timer2.time_left
	$Label2.text = "%.1f" % time_left_seconds

func _on_texture_button_pressed() -> void:
	$CanvasLayer4/CanvasModulate.color = Color(0, 0, 0, 1)
	code = code + "P"
	count += 1
	check_code()


func _on_texture_button_2_pressed() -> void:
	$CanvasLayer2/CanvasModulate.color = Color(0, 0, 0, 1)
	code = code + "y"
	count += 1
	check_code()

func _on_texture_button_3_pressed() -> void:
	$CanvasLayer3/CanvasModulate.color = Color(0, 0, 0, 1)
	code = code + "g"
	count += 1
	check_code()

func _on_texture_button_4_pressed() -> void:
	$CanvasLayer/CanvasModulate.color = Color(0, 0, 0, 1)
	code = code + 'p'
	count += 1
	check_code()
			

func _on_timer_2_timeout() -> void:
	$CanvasLayer5/Wrong.visible = true
	await get_tree().create_timer(2).timeout
	reset_puzzle()
	
func check_code():
	if count == 4:
		$Timer2.stop() 
		
		if code == "ypPg":
			$CanvasLayer5/Correct.visible = true
		else:
			$CanvasLayer5/Wrong.visible = true
			await get_tree().create_timer(2).timeout
			reset_puzzle()
			
func reset_puzzle():
	code = ""
	count = 0
	
	$CanvasLayer5/Wrong.visible = false
	$CanvasLayer5/Correct.visible = false
	
	$"Deskcloseup2".visible=false
	$"CanvasLayer".visible = false
	$"CanvasLayer2".visible = false
	$"CanvasLayer3".visible = false
	$"CanvasLayer4".visible = false
	$CanvasLayer/CanvasModulate.color = Color(1, 1, 1, 1)
	$CanvasLayer2/CanvasModulate.color = Color(1, 1, 1, 1)
	$CanvasLayer3/CanvasModulate.color = Color(1, 1, 1, 1)
	$CanvasLayer4/CanvasModulate.color = Color(1, 1, 1, 1)
	$AnimationPlayer.play("text")
	$Timer2.start()
