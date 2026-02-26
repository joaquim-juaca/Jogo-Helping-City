extends Node2D

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var pos = get_global_mouse_position()
		print("Clique em:", pos)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if event is InputEventMouseButton and event.pressed:
			get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_area_2d_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if event is InputEventMouseButton and event.pressed:
			get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_area_2d_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if event is InputEventMouseButton and event.pressed:
			get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_area_2d_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if event is InputEventMouseButton and event.pressed:
			get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_regiao1_mouse_exited():
	$Polygon2D.color = Color.WHITE
	
func ready() -> void:
	$sons/mapa.mp3.play()
