extends Node2D
func _ready() -> void:
	#Global.ending=1
	$continue.pressed.connect(pressed)
	$Menucard.visible=true
	$AnimationPlayer3.play("modulate")
	fade_out_music()
	
	if Global.ending  == 1:
		$ending1/Label.visible=true
		$ending1/Label2.visible=true
		$ending1/subtitle.visible=true
		$ending1/subtitle2.visible=true
		
	if Global.ending  == 2:
		$ending2/Label.visible=true
		$ending2/Label2.visible=true
		$ending2/subtitle.visible=true
		$ending2/subtitle2.visible=true
		
		
func pressed():
	$Menucard.visible=false
	$ending1/Label.visible=false
	$ending1/Label2.visible=false
	$ending1/subtitle.visible=false
	$ending1/subtitle2.visible=false
	$ending2/Label.visible=false
	$ending2/Label2.visible=false
	$ending2/subtitle.visible=false
	$ending2/subtitle2.visible=false
	$AnimationPlayer.play("type")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
func fade_out_music():
	var tween = create_tween()
	tween.tween_property(MusicManager.music_player, "volume_db", -40, 5.0)
