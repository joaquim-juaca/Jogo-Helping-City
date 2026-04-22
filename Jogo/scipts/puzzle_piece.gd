extends Area2D
class_name PuzzlePiece

@export var target_position: Vector2
@export var snap_distance: float = 80

var placed = false

@onready var sprite = $Sprite2D


func check_snap():

	if global_position.distance_to(target_position) < snap_distance:
		encaixar()


func encaixar():

	placed = true

	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 0.2)

	set_process(false)
