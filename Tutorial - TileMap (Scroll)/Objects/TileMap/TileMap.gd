extends Node2D

# Expose the map size, which can be set
export (Vector2) var mapSize setget setMapSize

# Expose the size of the tiles (this will be changed in the future to get the calculated size)
export (Vector2) var tileSize

func setMapSize(size):
	# Resize the map, if a Map object is a child
	if has_node("Map"):
		mapSize = size
		$Map.size = size

func putTile(cellPos, tile):
	# Add the tile to the Tiles Node2D in the TileMap instance, ensuring it is displayed
	$Tiles.add_child(tile)
	
	# Also place the tile into the Map
	placeTile(cellPos, tile)

func placeTile(cellPos, tile):
	# Place the specified tile into the Map cell positio
	$Map.put(cellPos, tile.type, tile)
	
	# Ensure the tile's cell position is updated, so that it knows where it is in the map
	tile.cellPos = cellPos

func getTile(cellPos, type):
	# Return the Tile type found at the cell position
	return $Map.get(cellPos, type)

func has(cellPos, type):
	# Return whether the tile type exists at the cell position
	return $Map.has(cellPos, type)

func liftTile(tile):
	# Remove the tile from the Map (Tile remains attached to Node2D Tiles so it shows on screen)
	$Map.remove(tile.cellPos, tile.type)
	return tile

func liftTileByPosAndType(cellPos, type):
	# If the Tile type exists at the specified cell position, then remove it from the Map (but not screen)
	var tile = $Map.get(cellPos, type)
	if tile != null:
		return liftTile(tile)
	return null

func removeTile(node, cellPos=null):
	# Lift the tile from the map
	liftTile(node)
	
	# Remove the tile from screen, but removing from the Node2D Tiles object in the TileMap instance
	$Tiles.remove_child(node)

func removeTileByPosAndType(cellPos, type):
	# Remove the tile type if found at the position and then remove it from the screen
	var tile = liftTileByPosAndType(cellPos, type)
	if tile != null:
		$Tiles.remove_child(tile)

func move(tile, newCellPos):
	# Lift the tile up, but keep on screen
	liftTile(tile)
	
	# Place the tile down in the new position
	placeTile(newCellPos, tile)

func onMap(cellPos):
	# Check whether the cell specified is constrained to the map dimension
	return $Map.onMap(cellPos)

func wrapPos(cellPos):
	# Check if the cell position is off the map, if it is then wrap around to be on it
	return $Map.wrapPos(cellPos)

func show(centerPos):
	var firstTilePos = centerPos - (mapSize / 2).floor()
	# Loop through each cell and display the dictionary list of tiles
	for y in range (int(mapSize.y)):
		var cellPos = Vector2(0, y)
		for x in range (int(mapSize.x)):
			cellPos.x = x
			var tilePos = wrapMapPos(firstTilePos + cellPos)
			showAllTiles(tilePos, cellPos)

func showAllTiles(tilePos, cellPos):
	# Get the list of all the tiles at the tile position
	var tileList = $Map.getAllTiles(tilePos)
	
	# For each tile, reposition the tile to the new screen position
	for type in tileList:
		var tile = tileList[type]
		tile.position = cellPos * tileSize

func wrapMapPos(cellPos):
	# Check that the cell position x and y are wrapped around
	cellPos.x = wrapTilePos(cellPos.x, mapSize.x)
	cellPos.y = wrapTilePos(cellPos.y, mapSize.y)
	return cellPos

func wrapTilePos(pos, wrapPos):
	# If the position is to the left/above then add the width/height to wrap position around
	if pos < 0:
		return wrapPos + pos
	# If the position is to the right/below then subtract the width/height to wrap position around
	elif pos >= wrapPos:
		return pos - wrapPos
	# Just return the position because it is within the map
	else:
		return pos
