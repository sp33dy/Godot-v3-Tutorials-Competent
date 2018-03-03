extends Node2D

# Preload the Partical Scene
const PARTICLE = preload("res://Particles/Particle.tscn")

# Expect the area to be specified
export (Rect2) var area

# Allow for the number of particles to be set, but default if not
export (int) var count = 20

# Once the Particles class is ready in the scene tree, check that it is 
# visible and area has been specified. IF so, create the Particles and add
# them as children.
func _ready():
	if area != null and visible:
		for i in range (count):
			var sprite = PARTICLE.instance()
			var x = area.position.x + randf() * (area.size.x - area.position.x)
			var y = area.position.y + randf() * (area.size.y - area.position.y)
			sprite.position = Vector2(x, y)
			sprite.wrapArea = area
			add_child(sprite)
