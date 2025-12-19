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
	
	$Area2D.connect("char_chosen", Callable(self, "_on_char_chosen"))
	$Area2D2.connect("char_chosen", Callable(self, "_on_char_chosen"))

func _on_char_chosen():
	if character_selected:
		return  # prevent double trigger
	character_selected = true
	print("Player chose a character!")
