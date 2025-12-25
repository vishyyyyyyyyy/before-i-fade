extends Node2D

@onready var narration_label: Label = $ghostlayer/explorelabel
@onready var explore_node: Node = $explore
var clicked_objects := {} 

func _ready() -> void:
	presentbox()
	$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	$ghostlayer/Bloodblanket.visible=true
	$ghostlayer/continue.pressed.connect(on_button_pressed)
	text()

func text():
	#if Global.character == "girlGhost":
		#$ghostlayer/ghosttext.play("girl")
	#if Global.character == "boyGhost":
		#$ghostlayer/ghosttext.play("boy")
	#await $ghostlayer/ghosttext.animation_finished
	#await atticmodulate()
	#if Global.character == "girlGhost":
		#$ghostlayer/pastchar1.play("girl")
	#if Global.character == "boyGhost":
		#$ghostlayer/pastchar1.play("boy")
	#await $ghostlayer/pastchar1.animation_finished
	#$ghostlayer/idle/girl.visible=false
	#$ghostlayer/idle/boy.visible=false
	#$ghostlayer/AnimationPlayer.play("death")
	#await $ghostlayer/AnimationPlayer.animation_finished
	#$ghostlayer/Bloodblanket.visible=true
	#if Global.character == "girlGhost":
		#$ghostlayer/ghosttext2.play("girl")
	#if Global.character == "boyGhost":
		#$ghostlayer/ghosttext2.play("boy")
	#await $ghostlayer/ghosttext2.animation_finished
	#$ghostlayer/explorelabel.visible=true
	#unlockexplore()
	challenge()
	
		
	
	#await afterpuzzle()
	#$ghostlayer/AnimationPlayer.play("death")
	#await $ghostlayer/AnimationPlayer.animation_finished
		
	#
#func atticmodulate():
	###past char in modulations
	#if Global.character =="boyGhost":
		#await get_tree().create_timer(0.5).timeout
		#$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		#$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		#pastbox()
		#$ghostlayer/idle/boy.visible=true
		#$ghostlayer/Bloodblanket.visible=false
		#await get_tree().create_timer(0.5).timeout
		#$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
		#$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
		#presentbox()
		#$ghostlayer/idle/boy.visible=false
		#$ghostlayer/Bloodblanket.visible=true
		#await get_tree().create_timer(0.5).timeout
		#$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		#$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		#pastbox()
		#$ghostlayer/Bloodblanket.visible=false
		#$ghostlayer/idle/boy.visible=true
		#
	#if Global.character =="girlGhost":
		#await get_tree().create_timer(0.5).timeout
		#$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		#$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		#presentbox()
		#$ghostlayer/idle/girl.visible=true
		#$ghostlayer/Bloodblanket.visible=false
		#await get_tree().create_timer(0.5).timeout
		#$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
		#$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
		#pastbox()
		#$ghostlayer/idle/girl.visible=true
		#$ghostlayer/Bloodblanket.visible=true
		#await get_tree().create_timer(0.5).timeout
		#$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		#$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		#presentbox()
		#$ghostlayer/Bloodblanket.visible=false
		#$ghostlayer/idle/girl.visible=true
#
#
#func unlockexplore():
	#$ghostlayer/explorelabel.visible=true
	#$explore/CanvasLayer/box/CollisionShape2D.disabled=false
	#$explore/CanvasLayer/box/CollisionShape2D2.disabled=false
	#$explore/CanvasLayer/box/CollisionShape2D3.disabled=false
	#$explore/CanvasLayer/box/CollisionShape2D4.disabled=false
	#$explore/CanvasLayer/box/CollisionShape2D5.disabled=false
	#$explore/CanvasLayer/box/CollisionShape2D6.disabled=false
	#$explore/CanvasLayer/box/CollisionShape2D7.disabled=false
	#$explore/CanvasLayer/box/CollisionShape2D8.disabled=false
	#$explore/CanvasLayer/box/CollisionShape2D9.disabled=false
	#$explore/CanvasLayer/box/CollisionShape2D10.disabled=false
	#$explore/CanvasLayer/box/CollisionShape2D11.disabled=false
	#$explore/CanvasLayer/box/CollisionShape2D12.disabled=false
	#$explore/CanvasLayer/window/CollisionShape2D.disabled=false
	#$explore/CanvasLayer/blanket/CollisionShape2D.disabled=false
	#
	#var areas = {
		#"window": $explore/CanvasLayer/window,
		#"blanket": $explore/CanvasLayer/blanket,
		#"box": $explore/CanvasLayer/box,
#
		#
	#}
	#for name in areas.keys():
			#var area_node = areas[name]
			#if area_node is Area2D:
				#area_node.clicked.connect(func(text):
					#_on_object_clicked(text, name)
			#)
#func _on_object_clicked(text: String, area_name: String):
	## If desk clicked before finishing others
	#if area_name == "box" and not all_non_photos_clicked():
		#narration_label.text = "Let's finish looking at everything else first."
		#narration_label.visible = true
		#return
## Mark this area as clicked
	#clicked_objects[area_name] = true
#
	## Update label
	#narration_label.text = text
	#narration_label.visible = true
	#
	#if area_name == "box" and all_non_photos_clicked():
		#print("yes")
		#$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
		#$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
		#presentbox()
		#await get_tree().create_timer(0.5).timeout
		#$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
		#$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
		#pastbox()
		#await get_tree().create_timer(0.5).timeout
		#$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
		#$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
		#presentbox()
		#if Global.character == "girlGhost":
			#$ghostlayer/ghosttext3.play("girl")
		#if Global.character == "boyGhost":
			#$ghostlayer/ghosttext3.play("boy")
		#await $ghostlayer/ghosttext3.animation_finished
		#challenge()
	#
		#
#func all_non_photos_clicked() -> bool:
	#var non_desk = ["blanket", "window"]
	#for name in non_desk:
		#if not clicked_objects.has(name): 
			#return false
	#return true
#
#






func afterpuzzle():
	#past char and then ex walk in close but not too close
	if Global.character == "girlGhost":
		$ghostlayer/chars2girl.play("girl")
		await $ghostlayer/chars2girl.animation_finished
		$ghostlayer/pastchar2.play("girl")
		await $ghostlayer/pastchar2.animation_finished
		$ghostlayer/chars2girl.play("kill")
		await $ghostlayer/pastchar2girl.animation_finished
			
	if Global.character == "boyGhost":
		$ghostlayer/chars2boy.play("boy")
		await $ghostlayer/chars2boy.animation_finished
		$ghostlayer/pastchar2.play("boy")
		await $ghostlayer/pastchar2.animation_finished
		$ghostlayer/chars2boy.play("death")
		await $ghostlayer/chars2boy.animation_finished
	#after animation finished, ex comes in closer fast so it looks like stab,
	#then it'll go to the screen with blood on it 


func challenge():
	$ghostlayer/continue/CollisionShape2D.disabled=false
	$ghostlayer/ColorRect.visible=true
	$ghostlayer/Menucard.visible=true
	$ghostlayer/Label.visible=true
	$ghostlayer/Label2.visible=true
	$ghostlayer/Label3.visible=true
	$ghostlayer/continue.visible=true
	
	
func on_button_pressed():
	$ghostlayer/Label9.visible=true
	$CanvasLayer/CanvasModulate.color = Color(1,1,1,1) 
	$CanvasLayer2/CanvasModulate.color =Color(1,1,1,1)
	pastbox()
	await get_tree().create_timer(20).timeout
	$CanvasLayer/CanvasModulate.color = Color(0.094, 0.323, 0.28) 
	$CanvasLayer2/CanvasModulate.color =Color(0.0, 0.992, 0.816)
	presentbox()

func pastbox():
	$CanvasLayer/CanvasModulate/box2/Box.visible=false
	$CanvasLayer/CanvasModulate/box2/Box2.visible=false
	$CanvasLayer/CanvasModulate/box2/Box3.visible=false
	$CanvasLayer/CanvasModulate/box2/Box4.visible=false
	$CanvasLayer/CanvasModulate/box2/Box5.visible=false
	$CanvasLayer/CanvasModulate/box2/Box6.visible=false
	$CanvasLayer/CanvasModulate/box2/Box7.visible=false
	$CanvasLayer/CanvasModulate/box2/Box8.visible=false
	$CanvasLayer/CanvasModulate/box2/Box9.visible=false
	$CanvasLayer/CanvasModulate/box2/Box10.visible=false
	$CanvasLayer/CanvasModulate/box2/Box11.visible=false
	$CanvasLayer/CanvasModulate/box2/Box12.visible=false
	
	
	$CanvasLayer/CanvasModulate/box/Box.visible=true
	$CanvasLayer/CanvasModulate/box/Box2.visible=true
	$CanvasLayer/CanvasModulate/box/Box3.visible=true
	$CanvasLayer/CanvasModulate/box/Box4.visible=true
	$CanvasLayer/CanvasModulate/box/Box5.visible=true
	$CanvasLayer/CanvasModulate/box/Box6.visible=true
	$CanvasLayer/CanvasModulate/box/Box7.visible=true
	$CanvasLayer/CanvasModulate/box/Box8.visible=true
	$CanvasLayer/CanvasModulate/box/Box9.visible=true
	$CanvasLayer/CanvasModulate/box/Box10.visible=true
	$CanvasLayer/CanvasModulate/box/Box11.visible=true
	$CanvasLayer/CanvasModulate/box/Box12.visible=true
	
func presentbox():
	$CanvasLayer/CanvasModulate/box/Box.visible=false
	$CanvasLayer/CanvasModulate/box/Box2.visible=false
	$CanvasLayer/CanvasModulate/box/Box3.visible=false
	$CanvasLayer/CanvasModulate/box/Box4.visible=false
	$CanvasLayer/CanvasModulate/box/Box5.visible=false
	$CanvasLayer/CanvasModulate/box/Box6.visible=false
	$CanvasLayer/CanvasModulate/box/Box7.visible=false
	$CanvasLayer/CanvasModulate/box/Box8.visible=false
	$CanvasLayer/CanvasModulate/box/Box9.visible=false
	$CanvasLayer/CanvasModulate/box/Box10.visible=false
	$CanvasLayer/CanvasModulate/box/Box11.visible=false
	$CanvasLayer/CanvasModulate/box/Box12.visible=false
	
	$CanvasLayer/CanvasModulate/box2/Box.visible=true
	$CanvasLayer/CanvasModulate/box2/Box2.visible=true
	$CanvasLayer/CanvasModulate/box2/Box3.visible=true
	$CanvasLayer/CanvasModulate/box2/Box4.visible=true
	$CanvasLayer/CanvasModulate/box2/Box5.visible=true
	$CanvasLayer/CanvasModulate/box2/Box6.visible=true
	$CanvasLayer/CanvasModulate/box2/Box7.visible=true
	$CanvasLayer/CanvasModulate/box2/Box8.visible=true
	$CanvasLayer/CanvasModulate/box2/Box9.visible=true
	$CanvasLayer/CanvasModulate/box2/Box10.visible=true
	$CanvasLayer/CanvasModulate/box2/Box11.visible=true
	$CanvasLayer/CanvasModulate/box2/Box12.visible=true
