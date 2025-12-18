extends CharacterBody2D

const speed = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walkSideways")
		elif movement == 0:
			anim.play("default")
	elif dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("walkSideways")
		elif movement == 0:
			anim.play("default")
	elif dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("walkBackward")
		elif movement == 0:
			anim.play("default")
	elif dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("walkForward")
		elif movement == 0:
			anim.play("default")
