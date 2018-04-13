extends Node

export (NodePath) var nodePathFactory = "../PathFactory"
export (int) var followerCount = 10
export (int) var followerGap = 32
export (bool) var closed = true
export (bool) var drawPathLine = false
export (Color) var pathColour = Color(0xffff00f0)
export (bool) var visible = false

const FOLLOWER = preload("res://Followers/Follower.tscn")

var path = [
	[Vector2(100, 100)],
	[Vector2(1820, 100)],
	[Vector2(1820, 980)],
	[Vector2(100, 980)]
]

func _ready():
	if nodePathFactory != null:
		if visible:
			var path = generatePath()
			if drawPathLine: 
				drawPathLine(path)
			addFollowers(path)
	else:
		print("Path to Factory Node not set! ", get_path())
		get_tree().quit()

func generatePath():
	return get_node(nodePathFactory).addPath(path, closed)

func drawPathLine(path):
	var line = Line2D.new()
	line.points = path.curve.get_baked_points()
	line.modulate = Color(pathColour)
	path.add_child(line)

func addFollowers(path):
	for i in range (followerCount):
		var follower = FOLLOWER.instance()
		follower.setInitOffset(i * -(followerGap))
		path.add_child(follower)
