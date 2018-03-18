extends Node2D

onready var SCREEN_SIZE = get_viewport().size

var points = [
	{ pos = Vector2(0,0), oldPos = Vector2(0,0)},
	{ pos = Vector2(100,0), oldPos = Vector2(100,0) },
	{ pos = Vector2(100,100), oldPos = Vector2(100,100)},
	{ pos = Vector2(0,100), oldPos = Vector2(0,100)}
]

var sticks = [
	{ p0 = 0, p1 = 1 },
	{ p0 = 1, p1 = 2 },
	{ p0 = 2, p1 = 3 },
	{ p0 = 3, p1 = 0 },
	{ p0 = 0, p1 = 2, hide = true }
]

var smoothing = 5
var bounce = 0.9
var gravity = 0.2
var resistance = 0.98
var friction = 0.90

func _ready():
	pickThrow()
	calcSticks()

func pickThrow():
	randomize()
	points[0].oldPos.x = randf() * 250.0

func calcSticks():
	for stick in sticks:
		stick.p0 = points[stick.p0]
		stick.p1 = points[stick.p1]
		stick.length = stick.p0.pos.distance_to(stick.p1.pos)
		$Frame.add_point(stick.p0.pos)

func _process(delta):
	updatePoints()
	for i in range (smoothing):
		updateSticks()
		constrainPoints()
	renderFrame()

func updatePoints():
	for point in points:
		applyMovement(point)

func applyMovement(point):
	var velocity = calcVelocity(point)
	point.oldPos = point.pos
	point.pos += velocity
	point.pos.y += gravity

func calcVelocity(point):
	var velocity = (point.pos - point.oldPos) * resistance
	if int(point.pos.y) == SCREEN_SIZE.y:
		if int(point.oldPos.y) == SCREEN_SIZE.y:
			velocity *= friction
	return velocity

func updateSticks():
	for stick in sticks:
		var d = stick.p1.pos - stick.p0.pos
		var distance = stick.p1.pos.distance_to(stick.p0.pos)
		var difference = stick.length - distance
		var percentage = difference / distance / 2
		d *= percentage
		stick.p0.pos -= d
		stick.p1.pos += d

func constrainPoints():
	for point in points:
		screenBounce(point)

func screenBounce(point):
	var velocity = calcVelocity(point)
	bounce(point, "x", SCREEN_SIZE.x, velocity)
	bounce(point, "y", SCREEN_SIZE.y, velocity)

func bounce(point, axis, size, velocity):
	if point.pos[axis] >=0 and point.pos[axis] <= size:
		return
	rebound(point, axis, size, velocity)

func rebound(point, axis, size, velocity):
	point.pos[axis] = (size if point.pos[axis] > 0 else 0)
	point.oldPos[axis] = point.pos[axis] + velocity[axis] * bounce

func renderFrame():
	for i in range (sticks.size()):
		$Frame.set_point_position(i, sticks[i].p0.pos)
