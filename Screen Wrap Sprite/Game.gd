extends Node

# Size of units to move player sprite
const MOVE_UNITS = 8

func _process(delta):
	# Detect a Cursor key and change Player position if one is pressed
	if Input.is_key_pressed(KEY_LEFT):
		$Player.position.x -= MOVE_UNITS
	if Input.is_key_pressed(KEY_RIGHT):
		$Player.position.x += MOVE_UNITS
	if Input.is_key_pressed(KEY_UP):
		$Player.position.y -= MOVE_UNITS
	if Input.is_key_pressed(KEY_DOWN):
		$Player.position.y += MOVE_UNITS
