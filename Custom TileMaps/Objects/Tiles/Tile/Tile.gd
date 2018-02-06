tool extends Node2D

export (String) var type
export (Vector2) var cellPos = Vector2(0, 0)
export (Texture) var texture setget setTexture

export (bool) var passable = true


func setTexture(newTexture):
	texture = newTexture
	if has_node("Texture"):
		update()

func update():
	if has_node("Texture"):
		$Texture.texture = texture

func _init():
	var sprite = Sprite.new()
	sprite.name = "Texture"
	add_child(sprite)

func _ready():
	update()
