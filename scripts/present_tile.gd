extends Node

var time_left_seconds
signal challengecompleted

var solution = {
	"tile1": "green",
	"tile2": "white",
	"tile3": "green",
	"tile4": "white",
	"tile5": "white",
	"tile6": "green",
	"tile7": "white",
	"tile8": "green",
	"tile9": "green",
	"tile10": "white",
	"tile11": "green",
	"tile12": "white",
	"tile13": "white",
	"tile14": "green",
	"tile15": "white",
	"tile16": "green"
}

var selected_colors = { 
	"tile1": "white",
	"tile2": "green",
	"tile3": "green",
	"tile4": "white",
	"tile5": "white",
	"tile6": "white",
	"tile7": "white",
	"tile8": "white",
	"tile9": "green",
	"tile10": "green",
	"tile11": "white",
	"tile12": "white",
	"tile13": "green",
	"tile14": "white",
	"tile15": "green",
	"tile16": "white"
}

var hearts = 3

func _ready(): 
	$tile1.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile2.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile3.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile4.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile5.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile6.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile7.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile8.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile9.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile10.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile11.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile12.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile13.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile14.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile15.connect("color_changed", Callable(self, "_on_tile_color_changed"))
	$tile16.connect("color_changed", Callable(self, "_on_tile_color_changed"))

func _process(delta: float) -> void:
	time_left_seconds = $"../Node3/Timer2".time_left
	$"../Node3/Label5".text = "%.1f" % time_left_seconds
	
func _on_tile_color_changed(tile_name: String, color: String):
	selected_colors[tile_name] = color
	print(tile_name, "is now", color)
	check_solution()

func _on_timer_2_timeout() -> void:
	print("lose")
	$"../Node3/Timer2".stop()
	$"../Node3/Wrong".visible=true
	$"../Node3/AudioStreamPlayer2".play()
	if Global.hardmode:
		Global.hearts -= 1
		if Global.hearts  ==2:
			$"../Heart3".visible=false
			$"../Heart6".visible=true
			
		elif Global.hearts  ==1:
			$"../Heart2".visible=false
			$"../Heart5".visible=true

		elif Global.hearts <= 0:
			$"../Heart".visible=false
			$"../Heart3".visible=true
			Global.hardmodefail=true
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://scenes/menu.tscn")
			return
		
		else:
			return


	else:
		hearts -= 1
		if hearts  ==2:
			$"../Heart3".visible=false
			$"../Heart6".visible=true
			
		elif hearts  ==1:
			$"../Heart2".visible=false
			$"../Heart5".visible=true

		elif hearts <= 0:
			$"../Heart".visible=false
			$"../Heart3".visible=true
			Global.hallwayfail = true
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://scenes/bathroom3.tscn")
			return
		
		else:
			return
	await get_tree().create_timer(2).timeout
	$"../Node3/Wrong".visible=false
	resetpuzzle()	

func check_solution():
	for tile_name in solution.keys():
		if selected_colors[tile_name] != solution[tile_name]:
			return
		if solution == selected_colors: 
			$"../Node3/Correct".visible=true
			$"../Node3/Timer2".stop()
			$"../Node3/Correct".visible=true
			$"../Node3/AudioStreamPlayer".play()
			emit_signal("challengecompleted")
			
func resetpuzzle():
	selected_colors = {
	"tile1": "white",
	"tile2": "green",
	"tile3": "green",
	"tile4": "white",
	"tile5": "white",
	"tile6": "white",
	"tile7": "white",
	"tile8": "white",
	"tile9": "green",
	"tile10": "green",
	"tile11": "white",
	"tile12": "white",
	"tile13": "green",
	"tile14": "white",
	"tile15": "green",
	"tile16": "white"
}
	$tile1.current_color = "white"
	$tile2.current_color = "green"
	$tile3.current_color = "green"
	$tile4.current_color = "white"
	$tile5.current_color = "white"
	$tile6.current_color = "white"
	$tile7.current_color = "white"
	$tile8.current_color = "white"
	$tile9.current_color = "green"
	$tile10.current_color = "green"
	$tile11.current_color = "white"
	$tile12.current_color = "white"
	$tile13.current_color = "green"
	$tile14.current_color = "white"
	$tile15.current_color = "green"
	$tile16.current_color = "white"


	$tile1/whitetile.modulate=Color(1,1,1,1)
	$tile2/greentile.modulate=Color(0.863, 1.0, 0.729)
	$tile3/greentile.modulate=Color(0.863, 1.0, 0.729)
	$tile4/whitetile.modulate=Color(1,1,1,1)
	$tile5/whitetile.modulate=Color(1,1,1,1)
	$tile6/whitetile.modulate=Color(1,1,1,1)
	$tile7/whitetile.modulate=Color(1,1,1,1)
	$tile8/whitetile.modulate=Color(1,1,1,1)
	$tile9/greentile.modulate=Color(0.863, 1.0, 0.729)
	$tile10/greentile.modulate=Color(0.863, 1.0, 0.729)
	$tile11/whitetile.modulate=Color(1,1,1,1)
	$tile12/whitetile.modulate=Color(1,1,1,1)
	$tile13/greentile.modulate=Color(0.863, 1.0, 0.729)
	$tile14/whitetile.modulate=Color(1,1,1,1)
	$tile15/greentile.modulate=Color(0.863, 1.0, 0.729)
	$tile16/whitetile.modulate=Color(1,1,1,1)

	$"../Node3/Timer2".start()
	
