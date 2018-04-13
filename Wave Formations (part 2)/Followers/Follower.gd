extends PathFollow2D

func setInitOffset(value):
	offset = value

func _process(delta):
	offset += 800 * delta
