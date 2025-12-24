extends Node2D

func _ready() -> void:
	
	if Global.reusablehallway ==4:
		$ghostlayer/Label.visible=true
		$ghostlayer/scenetrigger/CollisionShape2D.disabled=true
		$ghostlayer/scenetrigger/CollisionShape2D2.disabled=false
		Global.kitchen = 4
		print(Global.kitchen)
		
	if Global.livingroom == 1:
		Global.kitchen = 5
		$ghostlayer/scenetrigger/CollisionShape2D2.disabled=true
		$ghostlayer/scenetrigger/CollisionShape2D.disabled=false
		$ghostlayer/blobGhostPlayer.position.x=2137
		$ghostlayer/Label13.visible=true
		print("bathroom count: " + str(Global.bathroomCount))
		print("reusabledesk count: " + str(Global.reusabledesk))
		print("reusablehallway count: " + str(Global.reusablehallway))
		print("kitchen: " + str(Global.kitchen))
		print("livingroom: " + str(Global.livingroom))

		#var bathroomCount = 0
#var pastChar = ""
#var reusabledesk = 0
#var reusablehallway = 0
#var kitchen = 0
#var livingroom = 0
