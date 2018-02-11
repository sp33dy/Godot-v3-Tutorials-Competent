extends Node2D

# Expose a type name, which is used in the Map array as a unique identifier per cell
export (String) var type

# Expose a Vector cell position
export (Vector2) var cellPos = Vector2(0, 0)

# Expose a texture to be provided, as a single image or sprite map
export (Texture) var spriteMap setget setSpriteMap

# Expose a vector size that the sprite map is set to (defaulted to 1,1 for a single image)
export (Vector2) var spriteMapSize = Vector2(1, 1) setget setSpriteMapSize

# Expose an integer for the sprite frame to show
export (int) var frame setget setFrame

func setSpriteMap(newSpriteMap):
	# Store the new texture and then issue update to refresh Texture
	spriteMap = newSpriteMap
	update()

func setSpriteMapSize(newSize):
	# Store the new sprite map sie and refresh the texture
	spriteMapSize = newSize
	update()

func setFrame(index):
	# Store the new frame index and refresh the texture
	frame = index
	update()

func update():
	if has_node("Texture"):
		# If the texture has been added, ensure its properties are up to date
		$Texture.texture = spriteMap
		$Texture.vframes = (spriteMapSize.y if spriteMapSize != null else 1)
		$Texture.hframes = (spriteMapSize.x if spriteMapSize != null else 1)
		$Texture.frame = (frame if frame != null else 0)

func addTexture():
	# If a Sprite named Texture has not be added, add it as a child!
	if !has_node("Texture"):
		var sprite = Sprite.new()
		sprite.name = "Texture"
		add_child(sprite)

func _init():
	# On initialisation of any Tile, ensure a Sprite named Texture is added (this is the image to show)
	addTexture()

func _ready():
	# When the Tile is ready to show, make sure its properties are up to date
	update()
