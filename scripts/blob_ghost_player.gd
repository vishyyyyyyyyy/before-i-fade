extends CharacterBody2D

const speed = 300
var current_dir = "none"
var currentChar = Global.character

func _ready():
	if (currentChar == "blob"):
		$AnimatedSprite2D.play("blob_forward")
	else:
		$AnimatedSprite2D.play(currentChar + "_idle")

func _physics_process(delta):
	if (currentChar == "blob"):
		player_movement_blob(delta)
	else:
		player_movement(delta)

func player_movement_blob(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		velocity.x = 0
		velocity.y = -speed
	else:
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	
func player_movement(delta):
	var moving := false

	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity = Vector2(speed, 0)
		moving = true

	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity = Vector2(-speed, 0)
		moving = true

	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity = Vector2(0, speed)
		moving = true

	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity = Vector2(0, -speed)
		moving = true

	else:
		play_anim(0)
		velocity = Vector2.ZERO

	# 🔊 Audio control
	if moving:
		if not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.pitch_scale = randf_range(2.5, 2.75)
			$AudioStreamPlayer2D.play()
	else:
		$AudioStreamPlayer2D.stop()

	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if movement == 0:
		anim.speed_scale = 0.4   # slowwww for idl
	else:
		anim.speed_scale = 1.0   # normal
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play(currentChar + "_sideways")
		elif movement == 0:
			anim.play(currentChar + "_idle")

	elif dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play(currentChar + "_sideways")
		elif movement == 0:
			anim.play(currentChar + "_idle")

	elif dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play(currentChar + "_backward")
		elif movement == 0:
			anim.play(currentChar + "_idle")

	elif dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play(currentChar + "_forward")
		elif movement == 0:
			anim.play(currentChar + "_idle")
