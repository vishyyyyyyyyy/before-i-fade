extends Node2D
func _ready() -> void:
	$continue.pressed.connect(pressed)
	
	$Menucard.visible=true
	
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
	$AnimationPlayer/Label.visible=true
	$AnimationPlayer/Label2.visible=true
	$AnimationPlayer.play("type")
	
