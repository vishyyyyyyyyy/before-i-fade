extends Node2D

var code = ""
var count = 0

func _ready():
	$Node3/Label2.visible=true
	$Node3/Label.visible=true
	$Node3/Label3.visible=true
	$Node3/Menucard.visible=true
	$Node3/ColorRect.visible=true
	$Node3/continue.visible=true
	$Node3/continue.pressed.connect(_on_continue_pressed)


func _on_continue_pressed():
	print("Node was clicked!")
	$AnimationPlayer.play("text")
	$Node3/continue/CollisionShape2D.disabled=true
	$CanvasLayer.visible = true
	$CanvasLayer2.visible = true
	$CanvasLayer3.visible = true
	$CanvasLayer4.visible = true
	$Timer2.start()

func _process(delta: float) -> void:
	var time_left_seconds = $Timer2.time_left
	$Label2.text = "%.1f" % time_left_seconds

func _on_texture_button_pressed() -> void:
	$CanvasLayer4/CanvasModulate.color = Color(0, 0, 0, 1)
	code = code + "P"
	count += 1
	if (count == 4):
		if (code == "ypPg"):
			print("correct")


func _on_texture_button_2_pressed() -> void:
	$CanvasLayer2/CanvasModulate.color = Color(0, 0, 0, 1)
	code = code + "y"
	count += 1
	if (count == 4):
		if (code == "ypPg"):
			print("correct")

func _on_texture_button_3_pressed() -> void:
	$CanvasLayer3/CanvasModulate.color = Color(0, 0, 0, 1)
	code = code + "g"
	count += 1
	if (count == 4):
		if (code == "ypPg"):
			print("correct")

func _on_texture_button_4_pressed() -> void:
	$CanvasLayer/CanvasModulate.color = Color(0, 0, 0, 1)
	code = code + 'p'
	count += 1
	if (count == 4):
		if (code == "ypPg"):
			print("correct")
