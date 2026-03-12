extends Control
class_name DialogScreen

var _step : float = 0.05
var _id : int = 0
var data : Dictionary = {}
var _is_typing := false
var _char_index := 0
var _choices = []
var _choice_index := 0
var _choosing := false

@export_category("objects")
@export var _name : Label = null
@export var _dialog : RichTextLabel = null
@export var _faceset : TextureRect = null
@onready var _choices_label = $Background/Hcontainer/Vcontainer/ChoiceLabel

func _ready() -> void:
	_initialize_dialog()

func _process(_delta: float) -> void:

	if _is_typing:
		_char_index += 1
		_dialog.visible_characters = _char_index

		if _dialog.visible_characters >= _dialog.get_total_character_count():
			_is_typing = false
			
			if _choosing:
				_update_choices()
			return


	if _choosing and not _is_typing:
		_handle_choices()
		return


	if Input.is_action_just_pressed("ui_accept") and not _choosing:

		if _is_typing:
			_dialog.visible_characters = _dialog.get_total_character_count()
			_is_typing = false
			return

		_id += 1

		if data[_id].has("end"):
			queue_free()
			return

		_id += 1

		if _id >= data.size():
			queue_free()
			return

		_initialize_dialog()

func _initialize_dialog() -> void:
	if not data.has(_id):
		return

	_name.text = data[_id]["title"]
	_dialog.text = data[_id]["dialog"]
	_faceset.texture = load(data[_id]["faceset"])

	_dialog.visible_characters = 0
	_char_index = 0
	_is_typing = true
	_choices_label.text = ""
	_choosing = false
	
	if data[_id].has("choices"):
		_choices = data[_id]["choices"]
		_choice_index = 0
		_choosing = true
		
		_choices_label.custom_minimum_size = Vector2(0, 120)
		_choices_label.size_flags_vertical = Control.SIZE_EXPAND
	
	if not data[_id].has("choices"):
		_choices_label.custom_minimum_size.y = 0
		_choices_label.size_flags_vertical = Control.SIZE_FILL


func _handle_choices():

	if Input.is_action_just_pressed("ui_down"):
		_choice_index += 1
		if _choice_index >= _choices.size():
			_choice_index = 0
		_update_choices()

	if Input.is_action_just_pressed("ui_up"):
		_choice_index -= 1
		if _choice_index < 0:
			_choice_index = _choices.size() - 1
		_update_choices()

	if Input.is_action_just_pressed("ui_accept"):

		var escolha = _choices[_choice_index]

		print("Jogador escolheu:", escolha["text"])

		_choosing = false
		_choices_label.text = ""	

		# ir diretamente para o próximo diálogo definido
		_id = escolha["next"]

		_initialize_dialog()

func _update_choices():
	var texto := ""
	for i in range(_choices.size()):
		if i == _choice_index:
			texto += "> " + _choices[i]["text"] + "\n"
		else:
			texto += "  " + _choices[i]["text"] + "\n"	
	_choices_label.text = texto
