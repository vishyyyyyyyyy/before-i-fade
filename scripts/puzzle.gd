#extends Control  # Must be attached to a Node!
#
#var slots_root
#var pieces_root
#
#func _ready():
	#slots_root = get_node("Slots")
	#pieces_root = get_node("Pieces")
#
	## Connect pieces signals
	#for piece in pieces_root.get_children():
		#piece.connect("piece_snapped", Callable(self, "_on_piece_snapped"))
#
#
## Called when any piece snaps
#func _on_piece_snapped():
	#for picture_id in range(4):
		#if is_picture_complete(picture_id):
			#print("Picture", picture_id, "complete!")
	#if is_puzzle_complete():
		#print("🎉 Puzzle complete! 🎉")
#
#
## Check if a picture is complete
#func is_picture_complete(picture_id: int) -> bool:
	#for slot in slots_root.get_children():
		#if slot.picture_id == picture_id and not slot.occupied:
			#return false
	#return true
#
#
## Check if full puzzle is complete
#func is_puzzle_complete() -> bool:
	#for picture_id in range(4):
		#if not is_picture_complete(picture_id):
			#return false
	#return true
