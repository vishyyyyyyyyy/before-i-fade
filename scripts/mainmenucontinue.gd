extends Area2D
@export var normal_texture: Texture2D
@export var hover_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

signal pressed 
var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../easy".mode.connect(easymode)
	$"../hard".mode.connect(hardmode)
	
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
		counter +=1
		if counter == 1:
			$"../Node/Label".text = "Puzzles"
			$"../Node/Label2".text = "Puzzles"
			$"../Downarrow".visible=false
			$"../Uparrow".visible=false
			$"../LeftArrow".visible=false
			$"../Rightarrow".visible=false
			$"../Mouse".visible=false
			$"../Label".visible=false
			$"../Label2".visible=false
			$"../Label3".visible=false
			$"../Label4".visible=false
			$"../Door".visible=false
			$"../Door2".visible=false
			$"../Uibox".visible=false
			$"../Uibox2".visible=false
			$"../Uibox3".visible=false
			$"../Uibox4".visible=false
			$"../E".visible=false
			$"../Esc".visible=false
			$"../Esc2".visible=false
			$"../s".visible=false
			$"../w".visible=false
			$"../a".visible=false
			$"../d".visible=false
			$"../Brokenheart".visible=true
			$"../Heart".visible=true
			$"../Heart2".visible=true
			$"../Heart3".visible=true
			$"../Label5".visible=true
			$"../Label6".visible=true
			
		if counter == 2:
			$"../easy".visible=true
			$"../hard".visible=true
			$"../hard/CollisionShape2D".disabled=false
			$"../easy/CollisionShape2D".disabled=false
			$"../Uibox6".visible=true
			$"../Label7".visible=true
			$"../Uibox7".visible=true
			$"../Label8".visible=true
			$".".visible=false
			$CollisionShape2D.disabled=true
			
		if counter == 3:
			get_tree().change_scene_to_file("res://scenes/bedroom.tscn")

func easymode():
	Global.hardmode = false
	$"../easy".visible=false
	$"../hard".visible=false
	$"../hard/CollisionShape2D".disabled=true
	$"../easy/CollisionShape2D".disabled=true
	$"../Uibox6".visible=false
	$"../Label7".visible=false
	$"../Uibox7".visible=false
	$"../Label8".visible=false
	$"../Brokenheart".visible=false
	$"../Heart".visible=false
	$"../Heart2".visible=false
	$"../Heart3".visible=false
	$"../Label5".visible=false
	$"../Label6".visible=false
	$"../Node/Label".text = "Warning"
	$"../Node/Label2".text = "Warning"
	$"../AnimationPlayer".play("fade_in")
	await $"../AnimationPlayer".animation_finished
	$".".visible=true
	$CollisionShape2D.disabled=false
	$"../AnimationPlayer/Label".visible=true

func hardmode():
	Global.hardmode = true
	Global.hearts = 3
	print("HARDMODE FUNCTION CALLED")
	print("MODE:", Global.hardmode)
	print("GLOBAL HEARTS:", Global.hearts)
	$"../easy".visible=false
	$"../hard".visible=false
	$"../hard/CollisionShape2D".disabled=true
	$"../easy/CollisionShape2D".disabled=true
	$"../Uibox6".visible=false
	$"../Label7".visible=false
	$"../Uibox7".visible=false
	$"../Label8".visible=false
	$"../Brokenheart".visible=false
	$"../Heart".visible=false
	$"../Heart2".visible=false
	$"../Heart3".visible=false
	$"../Label5".visible=false
	$"../Label6".visible=false
	$"../Node/Label".text = "Warning"
	$"../Node/Label2".text = "Warning"
	$"../AnimationPlayer".play("fade_in")
	await $"../AnimationPlayer".animation_finished
	$".".visible=true
	$CollisionShape2D.disabled=false
	$"../AnimationPlayer/Label".visible=true
	
