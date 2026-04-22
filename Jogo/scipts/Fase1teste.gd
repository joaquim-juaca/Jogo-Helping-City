extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_property_list_changed() -> void:
	pass # Replace with function body.

var dialog_ja_exibido := false
var _dialog_instance : DialogScreen = null
const _DIALOG_SCREEN :PackedScene = preload("res://scenes/Dialogo.tscn")
var _dialog_data: Dictionary = {
	0: {
		"faceset" : "res://sprites/211 Sem Título_20260226095000.png",
		"dialog" : "Olá, eu sou o auxiliar da sua primeira missão, como pode ver uma senhora perdeu a sua casinha, precisamos da sua ajuda para reconstruí-la ! ",
		"title" : "Auxiliar De Infraestrutura"
	}
		
	
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
