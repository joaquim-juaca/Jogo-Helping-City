extends Node2D

var texture = preload("res://72eb903ee884f7c03d7fadd74616a457.jpg")

var total_pieces = 0
var placed_pieces = 0
var rows = 4
var cols = 4
var piece_size = 128

func _ready():
	create_pieces()

func create_pieces():

	for y in range(rows):
		for x in range(cols):

			var piece = Sprite2D.new()
			piece.texture = texture

			piece.region_enabled = true
			piece.region_rect = Rect2(
				x * piece_size,
				y * piece_size,
				piece_size,
				piece_size
			)

			piece.position = Vector2(
				randi() % 600,
				randi() % 400
			)

			add_child(piece)
			
func piece_placed():
	placed_pieces += 1

	if placed_pieces == total_pieces:
		puzzle_completed()
		
		
func puzzle_completed():
	print("Puzzle completo!")
