extends "res://SpriteScreenWrap/SpriteScreenWrap.gd"

var velocity
var direction

# When the Particle is ready in the scene tree, create a random velocity and
# direction
func _ready():
	velocity = randf() * 195.0 + 5.0
	direction = Vector2(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0) 

# At the next frame call, move the particle by the random values and the delta
# time
func _process(delta):
	position += (direction * velocity) * delta
