extends Node2D

# Preload the Partical Scene
const PARTICLE = preload("res://Particles/Particle.tscn")

# Expect the area to be specified
export (Rect2) var area

# Allow for the number of particles to be set, but default if not
export (int) var count = 20

func setArea():
	if area == null:
		area = Rect2(Vector2(), get_viewport().size)

# Once the Particles class is ready in the scene tree, check that it is 
# visible and area has been specified. IF so, create the Particles and add
# them as children.
func _ready():
	setArea()
	if visible:
		addParticles()

# Loop for the number of particles configured (default count = 20)
func addParticles():
	for i in range (count):
		# Create the Particle
		var sprite = PARTICLE.instance()
		# Randomise its screen start position
		var x = area.position.x + randf() * (area.size.x - area.position.x)
		var y = area.position.y + randf() * (area.size.y - area.position.y)
		sprite.position = Vector2(x, y)
		# Randomise its size using scale
		var scale = 0.2 + randf() * 0.8
		sprite.scale = Vector2(scale, scale)
		# Add the particle to the parent (Game Node)
		add_child(sprite)
