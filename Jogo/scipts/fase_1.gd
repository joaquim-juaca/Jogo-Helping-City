extends Node2D

# caminho da imagem do puzzle
@export var image_path: String = "res://sprites/241 Sem Título_20260408223607.png"

# quantidade de peças
@export var rows: int = 4
@export var cols: int = 4
var selected_piece = null
var offset = Vector2.ZERO
var total_pieces = 0
var texture = null
@onready var guide = $Guide
@onready var pieces_node = $Pieces
@onready var label = $UI/Label


func _ready():

	randomize()

	var texture = load(image_path)

	guide.texture = texture
	
	# NÃO definir scale aqui
	# guide.scale = Vector2.ONE
	
	guide.modulate.a = 0.3

	create_pieces()


func create_pieces():

	var texture = load(image_path)

	var original_size = texture.get_size()

	var piece_width = original_size.x / cols
	var piece_height = original_size.y / rows

	total_pieces = rows * cols

	for y in range(rows):

		for x in range(cols):

			create_piece(texture, x, y, piece_width, piece_height)
func create_piece(texture, x, y, piece_width, piece_height):

	var piece_scene = preload("res://scenes/PuzzlePiece.tscn")

	var piece = piece_scene.instantiate()

	var atlas = AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = Rect2(
		x * piece_width,
		y * piece_height,
		piece_width,
		piece_height
	)
	var sprite = piece.get_node("Sprite2D")
	sprite.texture = atlas

	# 🔥 CORREÇÃO DO PIVÔ
	sprite.centered = true
	sprite.offset = Vector2.ZERO
	piece.get_node("Sprite2D").texture = atlas

	# posição correta baseada na guide (sem scale)
	var target_pos = guide.global_position + Vector2(
	x * piece_width,
	y * piece_height
)

	piece.target_position = target_pos

	# posição inicial aleatória
	piece.global_position = Vector2(
		randf_range(100, 900),
		randf_range(100, 600)
	)

	pieces_node.add_child(piece)
func _process(delta):

	check_completion()
	if Input.is_action_just_pressed("ui_select") and not dialog_ja_exibido:

		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
		_new_dialog.data = _dialog_data
		_hud.add_child(_new_dialog)

		dialog_ja_exibido = true

func check_completion():

	var count = 0

	for piece in pieces_node.get_children():

		if piece.placed:

			count += 1

	if count == total_pieces:

		label.text = "Puzzle completo!"

func _input(event):

	# tecla para mostrar/esconder guia
	if event.is_action_pressed("ui_accept"):
		guide.visible = not guide.visible

	# clique do mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				select_piece_under_mouse()
			else:
				release_piece()

	# movimento do mouse (arrastar)
	if event is InputEventMouseMotion:
		if selected_piece != null and not selected_piece.placed:
			selected_piece.global_position = get_global_mouse_position() + offset
func select_piece_under_mouse():
	var mouse_pos = get_global_mouse_position()

	for piece in pieces_node.get_children():

		if piece.placed:
			continue

		var sprite = piece.get_node("Sprite2D")
		var tex_size = sprite.texture.get_size() * piece.scale
		var shink = 0.7
# calcula o retângulo da peça
		var rect = Rect2(
			piece.global_position - (tex_size * shink) / 2,
			tex_size * shink
		)

		# 🔥 verifica se o mouse está dentro do retângulo
		if rect.has_point(mouse_pos):

			selected_piece = piece

			# traz pra frente
			pieces_node.move_child(selected_piece, pieces_node.get_child_count() - 1)

			offset = selected_piece.global_position - mouse_pos
			return
func release_piece():

	if selected_piece != null:

		selected_piece.check_snap()

		# 🔥 se encaixou, limpa seleção imediatamente
		if selected_piece.placed:
			selected_piece = null
			return

		selected_piece = null
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


func _on_dialog_closed():
	_dialog_instance = null
