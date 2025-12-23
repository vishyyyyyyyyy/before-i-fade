extends TextureRect

@export var picture_id: int
@export var correct_slot_id: int

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
			else:
				dragging = false
				z_index = 0
				try_snap()

	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + drag_offset

func try_snap():
	var slots = get_tree().get_nodes_in_group("slots")
	var best_slot = null
	var min_dist := 40

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
