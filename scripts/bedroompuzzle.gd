extends Node2D

@onready var name_input: LineEdit = $LineEdit

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
	name_input.text_submitted.connect(_on_name_submitted)


var diary_started := false

func _input(event):
	if diary_started:
		return

	if event.is_action_pressed("ui_accept"):
		diary_started = true
		play_diary_sequence()

func _on_name_submitted(text: String):
	print("Player name:", text)
	Global.charName = text

func _on_continue_pressed():
	print("Node was clicked!")
	$Timer2.start()
	$TextureRect/TextureButton.disabled=true
	$TextureRect/TextureButton2.disabled=true
	$TextureRect/TextureButton3.disabled=true
	$TextureRect/TextureButton4.disabled=true
	$desk/CollisionShape2D.disabled=true
	$AnimationPlayer.play("text")
	await $AnimationPlayer.animation_finished
	$desk/CollisionShape2D.disabled=false
	$Node3/continue/CollisionShape2D.disabled=true
	$desk.clicked.connect(_on_desk_clicked)
	
	
func _on_desk_clicked():
	print("Clicked from main script!")
	$TextureRect/TextureButton.disabled=false
	$TextureRect/TextureButton2.disabled=false
	$TextureRect/TextureButton3.disabled=false
	$TextureRect/TextureButton4.disabled=false

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
	$AudioStreamPlayer2.play()
	await get_tree().create_timer(2).timeout
	reset_puzzle()
	
func check_code():
	if count == 4:
		
		if code == "ypPg":
			$Timer2.stop() 
			$AudioStreamPlayer.play()
			$CanvasLayer5/Correct.visible = true
			await get_tree().create_timer(2).timeout
			$CanvasLayer5/Correct.visible = false
			$AnimationPlayer/Label.visible=false
			$AnimationPlayer/Label3.visible=false
			correct()
		else:
			$CanvasLayer5/Wrong.visible = true
			$AudioStreamPlayer2.play()
			await get_tree().create_timer(2).timeout
			$CanvasLayer5/Correct.visible = false
			wrong()
			
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
	
func wrong():
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
	
func correct():
	$Node4/ColorRect3.visible=true
	$Node4/Diarypage.visible=true
	$Node4/Label2.visible=true
	$Node4/Label.visible=true
	$Node4/Label3.visible=true
	$Label2.visible=false
	$Timer.visible=false
	await get_tree().create_timer(5).timeout
	$"CanvasLayer".visible = false
	$"CanvasLayer2".visible = false
	$"CanvasLayer3".visible = false
	$"CanvasLayer4".visible = false
	$CanvasLayer5/Correct.visible = false
	$Node4/ColorRect3.visible=false
	$Node4/Diarypage.visible=false
	$Node4/Label2.visible=false
	$Node4/Label.visible=false
	$Node4/Label3.visible=false
	$Desk2.visible=true
	if Global.character == "girlGhost":
		$AnimationPlayer2.play("girlnametext")
		await $AnimationPlayer2.animation_finished
		$LineEdit.editable=true
		$LineEdit.visible=true
		
	if Global.character == "boyGhost":
		$AnimationPlayer2.play("boynametext")
		await $AnimationPlayer2.animation_finished
		$LineEdit.editable=true
		$LineEdit.visible=true


func play_diary_sequence():
	if Global.character == "girlGhost":
		$AnimationPlayer2/Label6.visible=false
		$LineEdit.editable=false
		$LineEdit.visible=false
		$Diaryentry1.visible=true
		$Deskcloseup2.visible=false
		$AnimationPlayer3.play("girldiaryentry1")
		$Desk2.visible=false
		await $AnimationPlayer3.animation_finished
		await get_tree().create_timer(2).timeout
		$AnimationPlayer3/Label4.visible=false
		$Label6.visible=true
		$AnimationPlayer3/GirlGhost.visible=false
		$AnimationPlayer3/BoyGhost.visible=false
		$AnimationPlayer2/GirlGhost.visible=false
		$AnimationPlayer2/BoyGhost.visible=false
		$Diaryentry1.visible=false
		$CanvasModulate/Calendar2.visible=true
		$CanvasModulate.color = Color(0.0, 0.994, 0.816)
		await get_tree().create_timer(0.5).timeout
		$CanvasModulate.color = Color(1,1,1,1)
		$CanvasModulate/Calendar2.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasModulate/Calendar2.visible=true
		$CanvasModulate.color = Color(0.0, 0.994, 0.816)
		$SceneTrigger/CollisionShape2D.disabled=false
		$Label6.visible=true
		
	if Global.character == "boyGhost":
		$AnimationPlayer2/Label6.visible=false
		$LineEdit.editable=false
		$LineEdit.visible=false
		$Diaryentry1.visible=true
		$Deskcloseup2.visible=false
		$AnimationPlayer3.play("boydiaryentry1")
		$Desk2.visible=false
		await $AnimationPlayer3.animation_finished
		await get_tree().create_timer(2).timeout
		$AnimationPlayer3/Label4.visible=false
		$Label6.visible=true
		$AnimationPlayer3/GirlGhost.visible=false
		$AnimationPlayer3/BoyGhost.visible=false
		$AnimationPlayer2/GirlGhost.visible=false
		$AnimationPlayer2/BoyGhost.visible=false
		$Diaryentry1.visible=false
		$CanvasModulate/Calendar2.visible=true
		$CanvasModulate.color = Color(0.0, 0.994, 0.816)
		await get_tree().create_timer(0.5).timeout
		$CanvasModulate.color = Color(1,1,1,1)
		$CanvasModulate/Calendar2.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasModulate/Calendar2.visible=true
		$CanvasModulate.color = Color(0.0, 0.994, 0.816)
		$SceneTrigger/CollisionShape2D.disabled=false
		$Label6.visible=true
