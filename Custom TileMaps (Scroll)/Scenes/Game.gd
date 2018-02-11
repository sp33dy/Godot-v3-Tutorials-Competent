extends Node

const TILE_PLAYER = preload("res://Objects/Tiles/Player/Player.tscn")
const TILE_FLOOR = preload("res://Objects/Tiles/Floor/Floor.tscn")

const DIRECTION_NONE = Vector2(0, 0)
const DIRECTION_NORTH = Vector2(0, -1)
const DIRECTION_EAST = Vector2(1, 0)
const DIRECTION_SOUTH = Vector2(0, 1)
const DIRECTION_WEST = Vector2(-1, 0)

const MAP_START = Vector2(0, 0)

var mapPos = MAP_START

func _ready():
	# Generate some random tiles
	generateMap()
	
	# Place the player into the map, so that he remains relative to it during movement
	$TileMap.placeTile(MAP_START, $Player)
	
	# Display the map from the starting position
	$TileMap.show(mapPos)

func generateMap():
	var index = 0
	# Loop through all cells, create floor instance and set its frame to the next value, wrapping it when required
	for y in range ($TileMap.mapSize.y):
		var cellPos = Vector2(0, y)
		for x in range ($TileMap.mapSize.x):
			var tileFloor = TILE_FLOOR.instance()
			index = (index if index < 260 else 0)
			tileFloor.frame = index
			cellPos.x = x
			$TileMap.putTile(cellPos, tileFloor)
			index += 1

func _input(event):
	# Wait for a key to be pressed
	if event.is_pressed():
		
		# Get the direction, if a cursor key is pressed
		var direction = getDirection(event)
		
		# Move the player. If a cursor key was not pressed then direction will be 0,0
		movePlayer(direction)
		
		# Move the map too!
		moveMap(direction)
		
		# Reposition ALL tiles and show them. This causes the illusion of scrolling
		$TileMap.show(mapPos)

func getDirection(event):
	# Check which key is pressed and return the Vector direction to add
	if event.is_action("ui_up"):
		return DIRECTION_NORTH
	elif event.is_action("ui_right"):
		return DIRECTION_EAST
	elif event.is_action("ui_down"):
		return DIRECTION_SOUTH
	elif event.is_action("ui_left"):
		return DIRECTION_WEST
	return DIRECTION_NONE

func movePlayer(direction):
	# Calculate the current position plus direction (might be 0,0)
	var destinationCellPos = $Player.cellPos + direction
	
	# Check whether the new position is off map, if it is, wrap to other side
	destinationCellPos = $TileMap.wrapMapPos(destinationCellPos)
	
	# Ask the TileMap object to move the player to the new cell
	$TileMap.move($Player, destinationCellPos)

func moveMap(direction):
	# calculate the new map position, ready for the show map function
	mapPos = $TileMap.wrapMapPos(mapPos + direction)
