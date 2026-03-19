extends Node

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
		$Label3.text = "You earned: Diary Page #%d\nAccess diary from desk to read contents" % pages[path]
