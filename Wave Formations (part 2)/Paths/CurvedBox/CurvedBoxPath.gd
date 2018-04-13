extends Node

export (NodePath) var nodePathFactory = "../PathFactory"
export (int) var followerCount = 10
export (int) var followerGap = 32
export (bool) var closed = false
export (bool) var drawPathLine = true
export (Color) var pathColour = Color(0xffffff80)
export (bool) var visible = false

const FOLLOWER = preload("res://Followers/Follower.tscn")

var path = [
	[Vector2(50+100, 50)],
	[Vector2(1920-50-100, 50), Vector2(), Vector2(50, 0)],
	[Vector2(1920-50, 50 + 100), Vector2(0, -50)],
	[Vector2(1920-50, 1080 - 100 - 50), Vector2(), Vector2(0, 50)],
	[Vector2(1920-50-100, 1080 - 50), Vector2(50, 0)],
	[Vector2(50+100, 1080 - 50), Vector2(), Vector2(-50, 0)],
	[Vector2(50, 1080 - 100 - 50), Vector2(0, 50)],
	[Vector2(50, 100 + 50), Vector2(), Vector2(0, -50)],
	[Vector2(50+100, 50), Vector2(-50, 0)]
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

func drawPathLine(path):
	var line = Line2D.new()
	line.points = path.curve.get_baked_points()
	line.modulate = Color(pathColour)
	path.add_child(line)

func generatePath():
	return get_node(nodePathFactory).addPath(path, closed)

func addFollowers(path):
	for i in range (followerCount):
		var follower = FOLLOWER.instance()
		follower.setInitOffset(i * -(followerGap))
		path.add_child(follower)
