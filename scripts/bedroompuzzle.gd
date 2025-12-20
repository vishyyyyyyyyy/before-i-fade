extends Node2D

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
