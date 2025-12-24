extends Area2D

@export var normal_texture: Texture2D
@export var hover_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	sprite.texture = normal_texture
	input_pickable = true

func _on_mouse_entered():
	sprite.texture = hover_texture
	print("hover works")
	
func _on_mouse_exited():
	sprite.texture = normal_texture
	print("exited")
	
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		clear_screen()
		add_screen()
		await get_tree().create_timer(7).timeout
		clear_screen2()
		add_screen2()

func clear_screen():
	$Sprite2D.visible=false
	$Label.visible=false
	$"../Music/Sprite2D".visible=false
	$"../Music/Label".visible=false
	$"../Title/Label".visible=false
	$"../Title/Label2".visible=false
	$"../Music/CollisionShape2D".disabled =true
	$CollisionShape2D.disabled=true
	$"../../subtitle".visible=false
	
	
func clear_screen2():
	$"../../Node3/Title/Label".visible=false
	$"../../Node3/Title/Label2".visible=false
	$"../../Downarrow".visible=false
	$"../../Uparrow".visible=false
	$"../../LeftArrow".visible=false
	$"../../Rightarrow".visible=false
	$"../../Mouse".visible=false
	$"../../Label".visible=false
	$"../../Label2".visible=false
	$"../../Label3".visible=false
	$"../../Door".visible=false
	$"../../Door2".visible=false
	
func add_screen():
	$"../../Node3/Title/Label".visible=true
	$"../../Node3/Title/Label2".visible=true
	$"../../Downarrow".visible=true
	$"../../Uparrow".visible=true
	$"../../LeftArrow".visible=true
	$"../../Rightarrow".visible=true
	$"../../Mouse".visible=true
	$"../../Label".visible=true
	$"../../Label2".visible=true
	$"../../Label3".visible=true
	$"../../Door".visible=true
	$"../../Door2".visible=true
	
func add_screen2():
	$"../../Node2/Title2/Label".visible=true
	$"../../Node2/Title2/Label2".visible=true
	$"../../Node2/AnimationPlayer/Label".visible=true
	$"../../Node2/AnimationPlayer".play("fade_in")
	$"../../Timer".start()


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/bedroom.tscn")
