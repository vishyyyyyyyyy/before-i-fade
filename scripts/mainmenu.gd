extends Node2D
func _ready() -> void:
	Global.character = "blob"
	Global.bathroomCount = 0
	Global.pastChar = ""
	Global.reusabledesk = 0
	Global.reusablehallway = 0
	Global.kitchen = 0
	Global.livingroom = 0
	Global.charName = ""
	Global.ending= 0
	MusicManager.music_player.pitch_scale = 1.0
	MusicManager.play_scene_music("menu")
	$AnimationPlayer2.play("modulate")
	await $AnimationPlayer2.animation_finished
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
	$Uibox.visible=true
	$Uibox2.visible=true
	$Uibox3.visible=true
	$subtitle.visible=false
	$Downarrow.visible=true
	$Uparrow.visible=true
	$LeftArrow.visible=true
	$Rightarrow.visible=true
	$Mouse.visible=true
	$Label.visible=true
	$Label2.visible=true
	$Label3.visible=true
	$Label4.visible=true
	$Door.visible=true
	$Door2.visible=true
	$continue.visible=true
	$Uibox4.visible=true
	$E.visible=true
	$Esc.visible=true
	$Esc2.visible=true
	$s.visible=true
	$w.visible=true
	$a.visible=true
	$d.visible=true
	$continue/CollisionShape2D.disabled=false
	
	
