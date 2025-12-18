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

func clear_screen():
	$Sprite2D.visible=false
	$Label.visible=false
	$"../Music/Sprite2D".visible=false
	$"../Music/Label".visible=false
	$"../Title/Label".visible=false
	$"../Title/Label2".visible=false
	$"../Music/CollisionShape2D".disabled =true
	$CollisionShape2D.disabled=true
	$"../../Node2/subtitle".visible=false
	# or load next scene
	# get_tree().change_scene_to_file("res://scenes/bedroom.tscn")

func add_screen():
	$"../../Node2/Title2/Label".visible=true
	$"../../Node2/Title2/Label2".visible=true
	$"../../Node2/AnimationPlayer/Label".visible=true
	$"../../Node2/AnimationPlayer".play("fade_in")
