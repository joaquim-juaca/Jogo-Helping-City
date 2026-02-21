extends Node2D

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var pos = get_global_mouse_position()
		print("Clique em:", pos)

var regiao1 = Rect2(Vector2(100, 100), Vector2(200, 150))
var regiao2 = Rect2(Vector2(400, 200), Vector2(150, 150))

func _entrada(event):
	if event is InputEventMouseButton and event.pressed:
		var pos = event.position 
		if regiao1.has_point(pos):
			get_tree().change_scene_to_file("res://scenes/Mapa.tscn")       
		elif regiao2.has_point(pos):
			get_tree().change_scene_to_file("res://scenes/Mapa.tscn")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if event is InputEventMouseButton and event.pressed:
			get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

	
func _on_regiao1_mouse_exited():
	$Polygon2D.color = Color.WHITE
