extends Area2D
signal challengecompleted
@onready var shapes = [
	[$CollisionShape2D,  "triangle", $CollisionShape2D/AudioStreamPlayer],
	[$CollisionShape2D2, "star",     $CollisionShape2D2/AudioStreamPlayer],
	[$CollisionShape2D3, "circle",   $CollisionShape2D3/AudioStreamPlayer],
	[$CollisionShape2D4, "arrow",    $CollisionShape2D4/AudioStreamPlayer],
	[$CollisionShape2D5, "x",        $CollisionShape2D5/AudioStreamPlayer],
	[$CollisionShape2D6, "diamond",  $CollisionShape2D6/AudioStreamPlayer],
	[$CollisionShape2D7, "cat",      $CollisionShape2D7/AudioStreamPlayer],
	[$CollisionShape2D8, "check",    $CollisionShape2D8/AudioStreamPlayer],
	[$CollisionShape2D9, "h",        $CollisionShape2D9/AudioStreamPlayer]
]
var solutions = [
	["triangle", "cat", "circle", "x"],
	["star", "arrow", "diamond", "check"],
	["star", "triangle", "arrow", "h", "cat", "circle", "diamond", "diamond"]
]

var current_solution := 0
var selected := []
var input_locked := false

# Called when the node enters the scene tree
func _ready() -> void:
	start_solution()

func _input_event(viewport, event, shape_idx):
	if input_locked:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		hidepianotile()

		var shape_node = shapes[shape_idx][0]
		var shape_name = shapes[shape_idx][1]
		var audio_player = shapes[shape_idx][2]

		shape_node.get_node("ColorRect").visible = true
		audio_player.play()
		selected.append(shape_name)

		if selected.size() == solutions[current_solution].size():
			check_solution()

func check_solution():
	input_locked = true

	if selected == solutions[current_solution]:
		print("✅ SOLUTION ", current_solution + 1, " CORRECT")

		current_solution += 1

	
		if current_solution == 1:
			$"../Music2".visible = true
			start_solution()

		elif current_solution == 2:
			$"../Music3".visible = true
			start_solution()
			
		elif current_solution == 3:
			
			print("🎉 ALL SOLUTIONS COMPLETE")
			$"../Correct".visible=true
			$"../AudioStreamPlayer".play()
			$"../Timer2".stop()
			await get_tree().create_timer(2).timeout
			$"../Timer".visible=false
			$"../Label8".visible=false
			$"../Correct".visible=false
			disablecollisionshape()
			emit_signal("challengecompleted")
			return
	else:
		$"../Wrong".visible=true
		$"../AudioStreamPlayer2".play()
		await get_tree().create_timer(2).timeout
		$"../Wrong".visible=false
		start_solution()
		

	input_locked = false



func start_solution():
	selected.clear()
	hidepianotile()

func hidepianotile():
	$CollisionShape2D/ColorRect.visible = false
	$CollisionShape2D2/ColorRect.visible = false
	$CollisionShape2D3/ColorRect.visible = false
	$CollisionShape2D4/ColorRect.visible = false
	$CollisionShape2D5/ColorRect.visible = false
	$CollisionShape2D6/ColorRect.visible = false
	$CollisionShape2D7/ColorRect.visible = false
	$CollisionShape2D8/ColorRect.visible = false
	$CollisionShape2D9/ColorRect.visible = false

func disablecollisionshape():
	$CollisionShape2D.disabled=true
	$CollisionShape2D2.disabled=true
	$CollisionShape2D3.disabled=true
	$CollisionShape2D4.disabled=true
	$CollisionShape2D5.disabled=true
	$CollisionShape2D6.disabled=true
	$CollisionShape2D7.disabled=true
	$CollisionShape2D8.disabled=true
	$CollisionShape2D9.disabled=true

func reset_to_beginning():
	current_solution = 0
	selected.clear()
	input_locked = false
	hidepianotile()
	$"../Music2".visible = false
	$"../Music3".visible = false


func _on_timer_2_timeout() -> void:
	$"../Wrong".visible = true
	$"../AudioStreamPlayer2".play()
	await get_tree().create_timer(2).timeout
	$"../Label8".add_theme_color_override("font_color", Color(0,0,0))
	$"../Timer2".start()
	$"../Wrong".visible = false
	reset_to_beginning()
