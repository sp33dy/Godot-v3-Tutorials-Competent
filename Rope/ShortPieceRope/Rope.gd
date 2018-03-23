extends Node2D

var PIECE = preload("res://ShortPieceRope/Piece.tscn")

export (int) var pieces = 1

func _ready():
	var parent = $Anchor
	for i in range (pieces):
		parent = addLink(parent)

func addLink(parent):
	var joint = parent.get_node("CollisionShape2D/Joint")
	var piece = PIECE.instance()
	joint.add_child(piece)
	joint.node_a = parent.get_path()
	joint.node_b = piece.get_path()
	return piece
