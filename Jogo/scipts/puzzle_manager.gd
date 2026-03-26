extends Node2D
class_name PuzzleManager

@export var puzzle_image: Texture2D
@export var grid_size: Vector2i = Vector2i(4, 4)
@export var piece_spacing: float = 10.0
@export var shuffle_range: float = 100.0

@onready var pieces_container: Node2D = $PiecesContainer
@onready var puzzle_board: ColorRect = $PuzzleBoard
@onready var puzzle_image_display: TextureRect = $UI/PuzzleImage
@onready var instructions: Label = $UI/Instructions
@onready var reset_button: Button = $UI/ResetButton
@onready var complete_label: Label = $UI/CompleteLabel
@onready var place_sound_player: AudioStreamPlayer = $PlaceSoundPlayer

var pieces: Array[PuzzlePiece] = []
var placed_count: int = 0
var total_pieces: int = 0
var place_sound = preload("res://sons/fmissoes.mp3")

func _ready():
	if not puzzle_image:
		push_error("No puzzle image assigned!")
		return
	
	total_pieces = grid_size.x * grid_size.y
	setup_puzzle()
	add_to_group("PuzzleManager")
	
	reset_button.pressed.connect(_on_reset_pressed)
	
	var image_size = puzzle_image.get_size()
	puzzle_board.size = image_size * 0.9
	puzzle_board.position = get_viewport_rect().size / 2 - puzzle_board.size / 2
	
	puzzle_image_display.texture = puzzle_image
	puzzle_image_display.size = puzzle_board.size
	puzzle_image_display.position = puzzle_board.position
	puzzle_image_display.modulate.a = 0.2
	
	place_sound_player.stream = place_sound

func setup_puzzle():
	for child in pieces_container.get_children():
		child.queue_free()
	
	pieces.clear()
	placed_count = 0
	
	var image_size = puzzle_image.get_size()
	var piece_size = Vector2(
		image_size.x / grid_size.x,
		image_size.y / grid_size.y
	)
	
	for row in range(grid_size.y):
		for col in range(grid_size.x):
			create_puzzle_piece(row, col, piece_size)
	
	shuffle_pieces()
	instructions.text = "Drag pieces to reconstruct the image!"

func create_puzzle_piece(row: int, col: int, piece_size: Vector2):
	var piece_scene = preload("res://scenes/piece.tscn")
	var piece = piece_scene.instantiate() as PuzzlePiece
	
	var source_rect = Rect2i(
		int(col * piece_size.x),
		int(row * piece_size.y),
		int(piece_size.x),
		int(piece_size.y)
	)
	
	var original_image = puzzle_image.get_image()
	var piece_image = Image.create(
		source_rect.size.x,
		source_rect.size.y,
		false,
		original_image.get_format()
	)
	
	piece_image.blit_rect(original_image, source_rect, Vector2i(0, 0))
	
	var piece_texture = ImageTexture.create_from_image(piece_image)
	
	piece.sprite.texture = piece_texture
	piece.sprite.scale = Vector2.ONE
	
	var board_center = puzzle_board.position + puzzle_board.size / 2
	var target_pos = board_center + Vector2(
		(col - grid_size.x / 2.0) * piece_size.x,
		(row - grid_size.y / 2.0) * piece_size.y
	)
	
	piece.target_position = target_pos
	piece.piece_index = row * grid_size.x + col
	piece.position = target_pos
	
	var shape = RectangleShape2D.new()
	shape.size = piece_size * 0.9
	piece.collision_shape.shape = shape
	
	pieces_container.add_child(piece)
	pieces.append(piece)

func shuffle_pieces():
	for piece in pieces:
		var screen_size = get_viewport_rect().size
		var random_pos = Vector2(
			randf_range(50, screen_size.x - 50),
			randf_range(50, screen_size.y - 100)
		)
		
		piece.global_position = random_pos
		piece.rotation_degrees = randf_range(-15, 15)
		piece.is_correctly_placed = false

func piece_placed(piece_index: int):
	placed_count += 1
	print("Piece ", piece_index, " placed! Progress: ", placed_count, "/", total_pieces)
	
	if place_sound_player.stream:
		place_sound_player.play()
	
	if placed_count >= total_pieces:
		puzzle_complete()

func puzzle_complete():
	instructions.text = "🎉 PUZZLE COMPLETE! 🎉"
	complete_label.text = "Perfect!"
	complete_label.visible = true
	puzzle_image_display.modulate.a = 0.0
	
	for piece in pieces:
		var tween = create_tween()
		tween.tween_property(piece, "scale", Vector2(1.1, 1.1), 0.1)
		tween.tween_property(piece, "scale", Vector2(1.0, 1.0), 0.1)

func _on_reset_pressed():
	setup_puzzle()
	complete_label.visible = false
