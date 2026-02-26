extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

	


func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MapaTeste.tscn")	

func _on_creditos_button_up() -> void:
	pass # Replace with function body.


func _on_sair_pressed() -> void:
	get_tree().quit()

func ready() -> void:
	$sons/inicial.mp3.play()
	
