extends Node

var paths = []

func clear():
	for path in paths:
		path.queue_free()
		paths.remove(path)

func getRndPath():
	return paths[randi() % paths.size()]

func getPathCount():
	return paths.size()

func findPath(path):
	return paths.find(path)

func getPath(index):
	return paths[index]

func addPath(points, closed=false):
	var curve = createCurve(points, closed)
	return createPath(curve)

func createCurve(points, closed=false):
	var curve = Curve2D.new()
	for point in points:
		var position = point[0]
		var inTan = (point[1] if point.size() > 1 else Vector2())
		var outTan = (point[2] if point.size() > 2 else Vector2())
		curve.add_point(position, inTan, outTan)
	if (closed):
		curve.add_point(curve.get_point_position(0))
	return curve

func createPath(curve):
	var path2D = Path2D.new()
	path2D.curve = curve
	paths.append(path2D)
	add_child(path2D)
	return path2D
