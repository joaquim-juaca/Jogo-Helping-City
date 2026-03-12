extends Node2D
class_name mapa


var dialog_ja_exibido := false
var _dialog_instance : DialogScreen = null
const _DIALOG_SCREEN :PackedScene = preload("res://scenes/Dialogo.tscn")
var _dialog_data: Dictionary = {
	0: {
		"faceset" : "res://sprites/211 Sem Título_20260226095000.png",
		"dialog" : "Olá seja bem vindo eu sou o administrador dessa cidade!",
		"title" : "Adiministrador"
	},
	1: {
		"faceset" : "res://sprites/211 Sem Título_20260226095000.png",
		"dialog" : "Você já deve ter observado que estamos passando por problemas aqui, tanto econômicos quanto sociais. Por isso escolhemos você para nos ajudar!",
		"title" : "Adiministrador"
	},
	2: {
		"faceset" : "res://sprites/211 Sem Título_20260226095000.png",
		"title" : "Adiministrador",
		"dialog": "Você aceita nos ajudar?",
		"choices": [
		{ "text": "Sim", "next": 3 },
		{ "text": "Não", "next": 4 }
		]
	},
	3: {
		"faceset" : "res://sprites/211 Sem Título_20260226095000.png",
		"dialog" : "Que ótimo! Vou lhe entregar o mapa da cidade, os círculos que você encontrar são os locais de sua missão, e cada um deles terá um auxiliar para ajudar na sua jornada, boa sorte!!",
		"title" : "Adiministrador",
		"end": true
	},
	4: {
		"faceset" : "res://sprites/211 Sem Título_20260226095000.png",
		"dialog" : "Que pena... precisamos de ajuda.	",
		"title" : "Adiministrador",
		"end": true
	},
		
	
}

@export_category("objects")
@export var _hud : CanvasLayer = null

func _process(_delta):

	if Input.is_action_just_pressed("ui_select") and not dialog_ja_exibido:

		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
		_new_dialog.data = _dialog_data
		_hud.add_child(_new_dialog)

		dialog_ja_exibido = true

func _on_dialog_closed():
	_dialog_instance = null

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var pos = get_global_mouse_position()
		print("Clique em:", pos)


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
		if event is InputEventMouseButton \
		and event.pressed \
		and event.button_index == MOUSE_BUTTON_LEFT:
		
			get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_area_2d_2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
		if event is InputEventMouseButton \
		and event.pressed \
		and event.button_index == MOUSE_BUTTON_LEFT:
		
			get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_area_2d_3_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
		if event is InputEventMouseButton \
		and event.pressed \
		and event.button_index == MOUSE_BUTTON_LEFT:
		
			get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_area_2d_4_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
		if event is InputEventMouseButton \
		and event.pressed \
		and event.button_index == MOUSE_BUTTON_LEFT:
		
			get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_regiao1_mouse_exited():
	$Polygon2D.color = Color.WHITE
	
func ready() -> void: 
	$sons/mapa.mp3.play()
