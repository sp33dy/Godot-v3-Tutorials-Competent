extends Node2D

const CHAIN_LOOP = preload("res://Chain/Loop/ChainLoop.tscn")
const CHAIN_LINK = preload("res://Chain/Link/ChainLink.tscn")

const CHAIN_LINK_LENGTH = 26

const GRAVITY = 0.6
const RESISTANCE = 0.98
const FRICTION = 0.90

var loops = []
var links = []

export (int) var linkCount = 10

onready var SCREEN_SIZE = get_viewport().size

func _ready():
	addAnchorLoop()
	for i in range (linkCount):
		addLoop(i)
		addLink(i)

func addAnchorLoop():
	loops.append($AnchorLoop)

func addLoop(index):
	var loop = CHAIN_LOOP.instance()
	loop.setPosition(index)
	loops.append(loop)
	add_child(loop)

func addLink(index):
	var link = CHAIN_LINK.instance()
	link.parentLoop = loops[index]
	link.childLoop = loops[index + 1]
	links.append(link)
	add_child(link)

func _process(delta):
	updateLoops()
	constrainLinks()
	renderFrame()

func updateLoops():
	for loop in loops:
		if !loop.anchor and !loop.over:
			applyMovement(loop)

func applyMovement(loop):
	var velocity = calcVelocity(loop)
	loop.oldPos = loop.pos
	loop.pos += velocity
	loop.pos.y += GRAVITY

func calcVelocity(loop):
	return (loop.pos - loop.oldPos) * RESISTANCE * FRICTION

func constrainLinks():
	for link in links:
		var vector = calcLinkVector(link)
		var distance = link.childLoop.pos.distance_to(link.parentLoop.pos)
		var difference = CHAIN_LINK_LENGTH - distance
		var percentage = difference / distance
		vector *= percentage
		link.childLoop.pos += vector

func calcLinkVector(link):
	return link.childLoop.pos - link.parentLoop.pos
	
func renderFrame():
	for link in links:
		link.childLoop.position = link.childLoop.pos
		positionLinkBetweenLoops(link)
		rotateLinkBetweenLoops(link)

func positionLinkBetweenLoops(link):
	link.position = link.parentLoop.pos + (calcLinkVector(link) / 2)

func rotateLinkBetweenLoops(link):
	link.global_rotation = link.parentLoop.pos.angle_to_point(link.childLoop.pos)
