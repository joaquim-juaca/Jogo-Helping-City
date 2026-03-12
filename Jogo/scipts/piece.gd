extends Node2D

var dragging = false
var correct_position
var placed = false

func _input(event):

	if placed:
		return

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed

	if event is InputEventMouseMotion and dragging:
		position += event.relative

func _process(delta):

	if placed:
		return

	if position.distance_to(correct_position) < 30:
		position = correct_position
		placed = true
