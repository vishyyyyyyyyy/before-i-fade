extends Node

var ghost_t := 0.0

func _ready() -> void:
	var pages = {
		"res://scenes/bedroompuzzle.tscn": 1,
		"res://scenes/bathroom3.tscn": 2,
		"res://scenes/hallway.tscn": 3,
		"res://scenes/kitchen.tscn": 4,
		"res://scenes/livingroom.tscn": 5,
		"res://scenes/attic.tscn": 6
	}

	var path = get_tree().current_scene.scene_file_path
	
	if path in pages:
		$Label3.text = "You earned: Diary Page #%d\nAccess diary from desk to read contents." % pages[path]

func _process(delta):
	ghost_t += delta
	
	var scale_amount = 4.0 + sin(ghost_t * 2.0) * 0.1
	$Diarypage.scale = Vector2(scale_amount, scale_amount)
	$Diarypage.rotation = sin(ghost_t * 1.5) * 0.08
