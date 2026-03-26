extends Node2D

@export var image_path: String = "res://72eb903ee884f7c03d7fadd74616a457.jpg"

@export var rows: int = 4
@export var cols: int = 4

var total_pieces = 0
var placed_pieces = 0

@onready var pieces_node = $Pieces
@onready var label = $UI/Label

func _ready():
	
	create_pieces()

func create_pieces():
	
	var texture = load(image_path)
	
	var piece_width = texture.get_width() / cols
	var piece_height = texture.get_height() / rows
	
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
	
	piece.get_node("Sprite2D").texture = atlas
	
	var target_pos = Vector2(
		x * piece_width,
		y * piece_height
	)
	
	piece.target_position = target_pos
	
	# posição inicial aleatória
	piece.position = Vector2(
		randf_range(0, 600),
		randf_range(0, 400)
	)
	
	pieces_node.add_child(piece)

func _process(delta):
	
	check_completion()

func check_completion():
	
	var count = 0
	
	for piece in pieces_node.get_children():
		
		if piece.placed:
			count += 1
	
	if count == total_pieces:
		
		label.text = "Puzzle completo!"
