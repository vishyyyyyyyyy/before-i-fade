extends Area2D
@export var normal_texture: Texture2D
@export var hover_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

signal pressed 
var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
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
			$"../Node/Title/Label".text = "Warning"
			$"../Node/Title/Label2".text = "Warning"
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
			$"../AnimationPlayer".play("fade_in")
			$"../AnimationPlayer/Label".visible=true
	if counter == 2:
		get_tree().change_scene_to_file("res://scenes/bedroom.tscn")
