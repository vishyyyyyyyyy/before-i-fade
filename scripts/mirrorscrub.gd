extends Area2D

@export var scrub_needed := 1500 # higher = longer cleaning

var scrub_amount := 0.0
var cleaned := false

@onready var dirty_sprite: Sprite2D = $"../DirtyMirror"
@onready var clean_sprite: Sprite2D = $"../CleanMirror"

func _ready():
	input_pickable = true
	clean_sprite.modulate.a = 0.0
	dirty_sprite.modulate.a = 1.0

func _input_event(viewport, event, shape_idx):
	if cleaned:
		return

	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		scrub_amount += event.relative.length() * 0.5
		update_fade()

func update_fade():
	var t: float = clamp(scrub_amount / scrub_needed, 0.0, 1.0)


	dirty_sprite.modulate.a = 1.0 - t
	clean_sprite.modulate.a = t

	if t >= 1.0:
		cleaned = true
		on_cleaned()

func on_cleaned():
	dirty_sprite.visible = false
	clean_sprite.modulate.a = 1.0
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$CollisionPolygon2D.disabled=true
	$"../../Sponge".visible=false
	$"../../Label2".visible=false
	$"../../Label3".visible=true
	$"../../ColorRect/boy".disabled = false
	$"../../ColorRect/girl".disabled = false
	$"../../Area2D2".visible=true
	$"../../Area2D".visible=true
	$"../../Area2D/CollisionShape2D3".disabled=false
	$"../../Area2D2/CollisionShape2D3".disabled=false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
