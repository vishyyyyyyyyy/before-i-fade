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
	
