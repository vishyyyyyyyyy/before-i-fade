extends Area2D
signal char_chosen

@export var normal_texture: Texture2D
@export var hover_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	sprite.texture = normal_texture
	input_pickable = true

func _on_mouse_entered():
	sprite.texture = hover_texture
	
func _on_mouse_exited():
	sprite.texture = normal_texture
	
var selected_character := ""
var girlcounter = 0
var boycounter = 0


func _on_boy_pressed(_viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		if selected_character == "boy" and boycounter == 1:
			print("press2boy")
			Global.character = "boyGhost"
			Global.pastChar = "pastBoy"
			$"../GirlGhost".visible = false
			emit_signal("char_chosen")
			boycounter =0
		else:
			print("press1boy")
			selected_character = "boy"
			boycounter = 1
			$"../BoyGhost".visible = true
			$"../GirlGhost".visible = false
		girlcounter = 0



func _on_girl_pressed(_viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		if selected_character == "girl" and girlcounter == 1:
			print("press2girl")
			Global.character = "girlGhost"
			Global.pastChar = "pastGirl"
			$"../BoyGhost".visible = false
			emit_signal("char_chosen")
			girlcounter = 0 
		else:
			selected_character = "girl"
			girlcounter = 1
			print("press1girl")
			$"../BoyGhost".visible = false
			$"../GirlGhost".visible = true
		
		boycounter = 0

			
	
