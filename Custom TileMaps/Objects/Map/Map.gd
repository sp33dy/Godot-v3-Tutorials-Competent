extends Node

export (Vector2) var size = Vector2(1, 1) setget setSize

var map = []

func setSize(newSize):
	size = newSize
	resize()

func resize():
	map = []
	for address in range (size.y * size.x):
		map.append({})

func calcAddress(cellPos):
	return (cellPos.y * size.x)+cellPos.x

func put(cellPos, type, object):
	if onMap(cellPos):
		map[calcAddress(cellPos)][type] = object

func get(cellPos, type):
	if has(cellPos,type):
		return map[calcAddress(cellPos)][type]
	return null

func has(cellPos, type):
	if onMap(cellPos):
		return map[calcAddress(cellPos)].has(type)
	return false

func remove(cellPos, type):
	if has(cellPos, type):
		map[calcAddress(cellPos)].erase(type)

func onMap(cellPos):
	if (cellPos.x < 0 or cellPos.x >= size.x):
		return false
	if (cellPos.y < 0 or cellPos.y >= size.y):
		return false
	return true

func wrapPos(cellPos):
	if !onMap(cellPos):
		wrapX(cellPos)
		wrapY(cellPos)
	return cellPos

func wrapX(cellPos):
	if cellPos.x < 0:
		cellPos.x += size.x
	elif cellPos.x >= size.x:
			cellPos.x -= size.x

func wrapY(cellPos):
	if cellPos.y < 0:
		cellPos.y += size.y
	elif cellPos.y >= size.y:
		cellPos.y -= size.y