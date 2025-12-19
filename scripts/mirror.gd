extends Node2D
var character_selected := false
func _ready():
	$ColorRect/boy.disabled=true
	$ColorRect/girl.disabled=true
	$Area2D/CollisionShape2D3.disabled=true
	$Area2D2/CollisionShape2D3.disabled=true
	$Node/Area2D/CollisionPolygon2D.disabled=true
	$Sponge.visible=false
	$AnimationPlayer.play("text")
	await $AnimationPlayer.animation_finished
	$Label2.visible=true
	$Sponge.visible=true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Node/Area2D/CollisionPolygon2D.disabled=false
	#await signals from area2d girl boy banners below
	$Area2D.connect("char_chosen", Callable(self, "_on_char_chosen"))
	$Area2D2.connect("char_chosen", Callable(self, "_on_char_chosen"))
	await$AnimationPlayer2.animation_finished
	get_tree().change_scene_to_file("res://scenes/bathroom2.tscn")

func _on_char_chosen():
	if character_selected:
		return 
	character_selected = true
	$Label3.visible=false
	$Area2D.visible=false
	$Area2D2.visible=false
	print("Player chose a character!")
	print(Global.character)
	if Global.character == "girlGhost":
		$GirlGhost.visible = false
		$AnimationPlayer2.play("girlghost")
	if Global.character == "boyGhost":
		$BoyGhost.visible = false
		$AnimationPlayer2.play("boyghost")
