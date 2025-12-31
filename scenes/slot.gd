extends Control

@export var picture_id: int
@export var slot_id: int
var occupied := false

func reset():
	occupied = false
