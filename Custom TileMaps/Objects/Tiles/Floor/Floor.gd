tool extends "res://Objects/Tiles/Tile/Tile.gd"

export (int, 0, 259) var tileId setget setTileById

func setTileById(newId):
	tileId = newId
	if tileId != null and has_node("Texture"):
		print("New frame index ",newId)
		$Texture.frame = newId

func _init():
	$Texture.scale = Vector2(2, 2)
	$Texture.vframes = 13
	$Texture.hframes = 20
	$Texture.frame = 1