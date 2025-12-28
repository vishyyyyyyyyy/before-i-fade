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

func _on_timer_2_timeout() -> void:
	print("lose")
	$"../../../ghostlayer/Timer2".stop()
	$"../../../ghostlayer/Wrong".visible=true
	$"../../../ghostlayer/AudioStreamPlayer2".play()
	await get_tree().create_timer(2).timeout
	$"../../../ghostlayer/Wrong".visible=false
	resetpuzzle()	
	

func resetpuzzle():
	selected_box = { 
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
	$box1/CollisionShape2D.disabled=true
	$box2/CollisionShape2D.disabled=true
	$box3/CollisionShape2D.disabled=true
	$box4/CollisionShape2D.disabled=true
	$box5/CollisionShape2D.disabled=true
	$box6/CollisionShape2D.disabled=true
	$box7/CollisionShape2D.disabled=true
	$box8/CollisionShape2D.disabled=true
	$box9/CollisionShape2D.disabled=true
	$box10/CollisionShape2D.disabled=true
	$box11/CollisionShape2D.disabled=true
	$box12/CollisionShape2D.disabled=true
	
	$"../../../ghostlayer/present".visible=false
	$"../../../ghostlayer/present2".visible=false
	$box1/Box2.visible=false
	$box2/Box2.visible=false
	$box3/Box2.visible=false
	$box4/Box2.visible=false
	$box5/Box2.visible=false
	$box6/Box2.visible=false
	$box7/Box2.visible=false
	$box8/Box2.visible=false
	$box9/Box2.visible=false
	$box10/Box2.visible=false
	$box11/Box2.visible=false
	$box12/Box2.visible=false
	
	$box1/Box.visible=false
	$box2/Box.visible=false
	$box3/Box.visible=false
	$box4/Box.visible=false
	$box5/Box.visible=false
	$box6/Box.visible=false
	$box7/Box.visible=false
	$box8/Box.visible=false
	$box9/Box.visible=false
	$box10/Box.visible=false
	$box11/Box.visible=false
	$box12/Box.visible=false
	$"../../../ghostlayer/Timer2".start()
	$"..".color = Color(1,1,1,1)
	$"../../../CanvasLayer2/CanvasModulate".color =Color(1,1,1,1)
	$"../../../ghostlayer/past".visible=true
	$"../../../ghostlayer/past2".visible=true
	#pastbox()
	$"../box/Box1".visible=true
	$"../box/Box2".visible=true
	$"../box/Box3".visible=true
	$"../box/Box4".visible=true
	$"../box/Box5".visible=true
	$"../box/Box6".visible=true
	$"../box/Box7".visible=true
	$"../box/Box8".visible=true
	$"../box/Box9".visible=true
	$"../box/Box10".visible=true
	$"../box/Box11".visible=true
	$"../box/Box12".visible=true
	$"../../../ghostlayer/Label8".visible=true
	await get_tree().create_timer(10).timeout
	$"../box/Box1".visible=false
	$"../box/Box2".visible=false
	$"../box/Box3".visible=false
	$"../box/Box4".visible=false
	$"../box/Box5".visible=false
	$"../box/Box6".visible=false
	$"../box/Box7".visible=false
	$"../box/Box8".visible=false
	$"../box/Box9".visible=false
	$"../box/Box10".visible=false
	$"../box/Box11".visible=false
	$"../box/Box12".visible=false
	
	
	$box1/Box.visible=true
	$box2/Box.visible=true
	$box3/Box.visible=true
	$box4/Box.visible=true
	$box5/Box.visible=true
	$box6/Box.visible=true
	$box7/Box.visible=true
	$box8/Box.visible=true
	$box9/Box.visible=true
	$box10/Box.visible=true
	$box11/Box.visible=true
	$box12/Box.visible=true
	
	
	$"../../../ghostlayer/past".visible=false
	$"../../../ghostlayer/past2".visible=false
	$"..".color = Color(0.094, 0.323, 0.28) 
	$"../../../CanvasLayer2/CanvasModulate".color =Color(0.0, 0.992, 0.816)
	$"../../../ghostlayer/Label8".visible=true
	$"../../../ghostlayer/present".visible=true
	$"../../../ghostlayer/present2".visible=true

	$box1/CollisionShape2D.disabled=false
	$box2/CollisionShape2D.disabled=false
	$box3/CollisionShape2D.disabled=false
	$box4/CollisionShape2D.disabled=false
	$box5/CollisionShape2D.disabled=false
	$box6/CollisionShape2D.disabled=false
	$box7/CollisionShape2D.disabled=false
	$box8/CollisionShape2D.disabled=false
	$box9/CollisionShape2D.disabled=false
	$box10/CollisionShape2D.disabled=false
	$box11/CollisionShape2D.disabled=false
	$box12/CollisionShape2D.disabled=false

	
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
