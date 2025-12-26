extends Node

var time_left_seconds
signal challengecompleted

var solution = {
	"box1": "open",
	"box2": "closed",
	"box3": "closed",
	"box4": "open",
	"box5": "open",
	"box6": "closed",
	"box7": "closed",
	"box8": "open",
	"box9": "open",
	"box10": "closed",
	"box11": "closed",
	"box12": "open"
}

var selected_box = { 
	"box1": "closed",
	"box2": "closed",
	"box3": "closed",
	"box4": "closed",
	"box5": "closed",
	"box6": "closed",
	"box7": "closed",
	"box8": "closed",
	"box9": "closed",
	"box10": "closed",
	"box11": "closed",
	"box12": "closed"
	
	
	
}

func _ready():
	$box1.connect("box_changed", Callable(self, "_on_box_changed"))
	$box2.connect("box_changed", Callable(self, "_on_box_changed"))
	$box3.connect("box_changed", Callable(self, "_on_box_changed"))
	$box4.connect("box_changed", Callable(self, "_on_box_changed"))
	$box5.connect("box_changed", Callable(self, "_on_box_changed"))
	$box6.connect("box_changed", Callable(self, "_on_box_changed"))
	$box7.connect("box_changed", Callable(self, "_on_box_changed"))
	$box8.connect("box_changed", Callable(self, "_on_box_changed"))
	$box9.connect("box_changed", Callable(self, "_on_box_changed"))
	$box10.connect("box_changed", Callable(self, "_on_box_changed"))
	$box11.connect("box_changed", Callable(self, "_on_box_changed"))
	$box12.connect("box_changed", Callable(self, "_on_box_changed"))

	
func _on_box_changed(box_name: String, box: String):
	selected_box[box_name] = box
	check_solution()

#func _on_timer_2_timeout() -> void:
	#print("lose")
	#$"../Node3/Timer2".stop
	#$"../Node3/Wrong".visible=true
	#$"../Node3/AudioStreamPlayer2".play()
	#await get_tree().create_timer(2).timeout
	#$"../Node3/Wrong".visible=false
	#resetpuzzle()	
#
func check_solution():
	for box_name in solution.keys():
		if selected_box[box_name] != solution[box_name]:
			return

	# All matched
	print("yay")
	$"../../../ghostlayer/Timer2".stop()
	$"../../../ghostlayer/Correct".visible=true
	$"../../../ghostlayer/AudioStreamPlayer".play()
	emit_signal("challengecompleted")
