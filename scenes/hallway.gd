extends Node2D


func _ready() -> void:
	Global.reusabledesk += 1
	ghosttext1()

func ghosttext1():
	if Global.character == "girlGhost":
		$CanvasLayer/ghosttext1.play("girltext")
		await $CanvasLayer/ghosttext1.animation_finished
		modulate()
	if Global.character == "boyGhost":
		$CanvasLayer/ghosttext1.play("boytext")
		await $CanvasLayer/ghosttext1.animation_finished
		modulate()
		
func modulate():
	if Global.character == "girlGhost":
		$CanvasLayer3/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=true
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=true
		$CanvasLayer3/CanvasModulate/Boyframe5.visible=true
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece2.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece3.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece4.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer3/CanvasModulate.color = Color(0.0, 0.992, 0.816)
		$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.322, 0.278)
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=false
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=false
		$CanvasLayer3/CanvasModulate/Boyframe5.visible=false
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece2.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece3.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece4.visible=true
		
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer3/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=true
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=true
		$CanvasLayer3/CanvasModulate/Boyframe5.visible=true
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece2.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece3.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece4.visible=false
		await get_tree().create_timer(0.5).timeout
		$"CanvasLayer/neighbor talk".play("neighbortext")
		await $"CanvasLayer/neighbor talk".animation_finished
		$CanvasLayer/ghosttext2.play("girlghosttext")
		await $CanvasLayer/ghosttext2.animation_finished
		
	if Global.character == "boyGhost":
		$CanvasLayer3/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=true
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=true
		$CanvasLayer3/CanvasModulate/Girlframe5.visible=true
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece2.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece3.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece4.visible=false
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer3/CanvasModulate.color = Color(0.0, 0.992, 0.816)
		$CanvasLayer2/CanvasModulate.color = Color(0.094, 0.322, 0.278)
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=false
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=false
		$CanvasLayer3/CanvasModulate/Girlframe5.visible=false
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece2.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece3.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece4.visible=true
		
		await get_tree().create_timer(0.5).timeout
		$CanvasLayer3/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer2/CanvasModulate.color = Color(1,1,1,1)
		$CanvasLayer3/CanvasModulate/Auntframe5.visible=true
		$CanvasLayer3/CanvasModulate/Friendframe5.visible=true
		$CanvasLayer3/CanvasModulate/Girlframe5.visible=true
		$CanvasLayer3/CanvasModulate/Neigborframe5.visible=true
		$CanvasLayer3/CanvasModulate/Picturepiece.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece2.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece3.visible=false
		$CanvasLayer3/CanvasModulate/Picturepiece4.visible=false
		await get_tree().create_timer(0.5).timeout
		$"CanvasLayer/neighbor talk".play("neighbortext")
		await $"CanvasLayer/neighbor talk".animation_finished
		$CanvasLayer/ghosttext2.play("boyghosttext")
		await $CanvasLayer/ghosttext2.animation_finished

	
