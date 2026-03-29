extends CharacterBody2D

const speed = 295
var current_dir = "none"
var currentChar = Global.character
var ghost_t := 0.0

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
	handle_ghost_fade(delta)

func handle_ghost_fade(delta):
	var anim = $AnimatedSprite2D
	ghost_t += delta
	
	# fade in outt
	var alpha = 0.95 + sin(ghost_t * 2.0) * 0.07
	anim.modulate.a = alpha
		
func player_movement_blob(delta):
	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1

	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		velocity = input_dir * speed
		update_direction(input_dir)
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	
func player_movement(delta):
	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1

	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		velocity = input_dir * speed
		update_direction(input_dir)
		play_anim(1)
	else:
		velocity = Vector2.ZERO
		play_anim(0)

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
			
func update_direction(dir: Vector2):
	# prioritize horizontal movement (this handles diagonals)
	if dir.x != 0:
		if dir.x > 0:
			current_dir = "right"
		else:
			current_dir = "left"
	else:
		if dir.y > 0:
			current_dir = "down"
		else:
			current_dir = "up"
