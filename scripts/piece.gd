extends TextureRect

@export var picture_id: int
@export var correct_slot_id: int
@export var drag_tint: Color = Color(0.8, 0.8, 1.0, 1.0) # light blue tint
signal piece_snapped


var dragging := false
var drag_offset := Vector2.ZERO
var locked := false

func _gui_input(event):
	if locked:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_offset = global_position - get_global_mouse_position()
				z_index = 100
				
				modulate = drag_tint  # 🎨 apply tint

			else:
				dragging = false
				z_index = 0
				
				modulate = Color(1, 1, 1, 1)  # 🎨 remove tint
				
				try_snap()

	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + drag_offset

func try_snap():
	var slots = get_tree().get_nodes_in_group("slots")
	var best_slot = null
	var min_dist := 100

	for slot in slots:
		if slot.occupied:
			continue
		if slot.picture_id != picture_id:
			continue

		var dist = global_position.distance_to(slot.global_position)
		if dist < min_dist:
			min_dist = dist
			best_slot = slot

	if best_slot and best_slot.slot_id == correct_slot_id:
		snap_to_slot(best_slot)


func snap_to_slot(slot):
	global_position = slot.global_position
	locked = true
	slot.occupied = true
	
	modulate = Color(1, 1, 1, 1)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	emit_signal("piece_snapped")

func reset():
	locked = false
	z_index = 0
	mouse_filter = Control.MOUSE_FILTER_STOP
	modulate = Color(1, 1, 1, 1)
