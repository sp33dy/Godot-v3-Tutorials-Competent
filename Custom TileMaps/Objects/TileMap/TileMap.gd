extends Node2D

export (Vector2) var mapSize setget setMapSize
export (Vector2) var tileSize

func setMapSize(newSize):
	if has_node("Map"):
		$Map.size = newSize

func put(cellPos, tile):
	positionTile(cellPos, tile)
	add_child(tile)
	$Map.put(cellPos, tile.type, tile)

func positionTile(cellPos, tile):
	tile.cellPos = cellPos
	tile.position = cellPos * tileSize

func get(cellPos, type):
	return $Map.get(cellPos, type)
	
func has(cellPos, type):
	return $Map.has(cellPos, type)

func remove(cellPos, type):
	var object = $Map.get(cellPos, type)
	if object != null:
		$Map.remove(cellPos, type)
		remove_child(object)

func move(tile, newCellPos):
	$Map.remove(tile.cellPos, tile.type)
	$Map.put(newCellPos, tile.type, tile)
	positionTile(newCellPos, tile)

func onMap(cellPos):
	return $Map.onMap(cellPos)

func wrapPos(cellPos):
	return $Map.wrapPos(cellPos)
