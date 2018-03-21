extends Node2D

const LOOP = preload("res://Chain/Loop/Loop.tscn")
const LINK = preload("res://Chain/Link/Link.tscn")

export (int) var loops = 1

func _ready():
	var parent = $Anchor
	for i in range (loops):
		var child = addLoop(parent)
		addLink(parent, child)
		parent = child

func addLoop(parent):
	var loop = LOOP.instance()
	loop.position = parent.position
	loop.position.y += 26
	add_child(loop)
	return loop

func addLink(parent, child):
	var pin = LINK.instance()
	pin.node_a = parent.get_path()
	pin.node_b = child.get_path()
	parent.add_child(pin)
