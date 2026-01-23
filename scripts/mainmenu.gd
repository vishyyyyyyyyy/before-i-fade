extends Node2D
func _ready() -> void:
	#$Node/Play/CollisionShape2D.disabled=true
	#$Node/Music/CollisionShape2D.disabled=true
	#$Node4/AnimationPlayer.play("fadein")
	#await $Node4/AnimationPlayer.animation_finished
	$Node/Play/CollisionShape2D.disabled=false
	$Node/Music/CollisionShape2D.disabled=false
	$Node/Play.play.connect(play)
	
func play():
	$Node/Play.visible=false
	$Node/Play/CollisionShape2D.disabled=true
	$Node/Music.visible=false
	$Node/Music/CollisionShape2D.disabled=true
	$Node/Title/Label.text = "Controls"
	$Node/Title/Label2.text= "Controls"
	$subtitle.visible=false
	$Downarrow.visible=true
	$Uparrow.visible=true
	$LeftArrow.visible=true
	$Rightarrow.visible=true
	$Mouse.visible=true
	$Label.visible=true
	$Label2.visible=true
	$Label3.visible=true
	$Door.visible=true
	$Door2.visible=true
	$continue.visible=true
	$continue/CollisionShape2D.disabled=false
	
	
