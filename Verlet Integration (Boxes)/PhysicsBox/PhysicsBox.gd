extends RigidBody2D

func _init():
	angular_velocity = randf() * 5.0
	linear_velocity = Vector2(randf() * 700.0, 0.0)
