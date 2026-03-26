extends Area2D
class_name PuzzlePiece

@export var target_position: Vector2
@export var snap_distance: float = 20

var dragging = false
var placed = false
var offset = Vector2.ZERO

func _ready():
	input_pickable = true

func _input_event(viewport, event, shape_idx):
	
	# clique do mouse
	if event is InputEventMouseButton:
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			
			if event.pressed and not placed:
				dragging = true
				offset = global_position - get_global_mouse_position()
			
			elif not event.pressed:
				dragging = false
				check_snap()

func _process(delta):
	
	if dragging:
		global_position = get_global_mouse_position() + offset

func check_snap():
	
	# verifica se está perto da posição correta
	if global_position.distance_to(target_position) < snap_distance:
		
		global_position = target_position
		
		placed = true
		
		# impede que seja arrastado novamente
		set_process(false)
