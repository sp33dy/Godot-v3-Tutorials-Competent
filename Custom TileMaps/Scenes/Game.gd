extends Node

const TILE_FLOOR = preload("res://Objects/Tiles/Floor/Floor.tscn")

func _ready():
	var index = 0
	for y in range (13):
		var cellPos = Vector2(0, y)
		for x in range (20):
			var tileFloor = TILE_FLOOR.instance()
			tileFloor.tileId = index
			cellPos.x = x
			$TileMap.put(cellPos, tileFloor)
			index += 1

