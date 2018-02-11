extends Node

# Expose the ability to resize the map
export (Vector2) var size = Vector2(1, 1) setget setSize

var map = []

func setSize(newSize):
	# Accept a new size and resize the map
	size = newSize
	resizeMap()

func resizeMap():
	# Allocate a new array and create an empty dictionary per cell
	map = []
	for address in range (size.y * size.x):
		map.append({})

func calcAddress(cellPos):
	# Convert the Vector into a scalar (single) address into the map
	return (cellPos.y * size.x) + cellPos.x

func put(cellPos, type, object):
	# If the cell position is on the map, place the tile into the cell dictionary using its type
	if onMap(cellPos):
		map[calcAddress(cellPos)][type] = object

func get(cellPos, type):
	# If the cell position is on the map, return the tile type at the specified position
	if has(cellPos, type):
		return map[calcAddress(cellPos)][type]
	return null

func getAllTiles(cellPos):
	# Return the dictionary list at the specified position
	return map[calcAddress(cellPos)]

func has(cellPos, type):
	# Check if the specified position is on the map and has the specific type of tile
	if onMap(cellPos):
		return map[calcAddress(cellPos)].has(type)
	return false

func remove(cellPos, type):
	# Remove the specified tile from the cell dictionary if it exists
	if has(cellPos, type):
		map[calcAddress(cellPos)].erase(type)

func onMap(cellPos):
	# Check that the position is within the map dimensions
	if (cellPos.x < 0 or cellPos.x >= size.x):
		return false
	if (cellPos.y < 0 or cellPos.y >= size.y):
		return false
	return true
