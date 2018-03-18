extends Node

# Expose a Rectangle area to the tool, so that it can be defined
export (Rect2) var wrapArea = null

# Expose two flags to determine which axes shall be wrapped; both defaulted true
export (bool) var horizontalWrapping = true
export (bool) var verticalWrapping = true

# Dictionary of axis directions
var AXIS = {
	HORIZONTAL = "x",
	VERTICAL = "y"
}

# Initialise the wrap area to screen size if not set
func initWrapArea():
	if wrapArea == null:
		wrapArea = Rect2(Vector2(), get_viewport().size)

# When node ready, set the inital wrap area if not set
func _ready():
	initWrapArea()

# Check whether the parent object is NOT in the wrap area,
# call the wrap function if it isn't
func _process(delta):
	if !wrapArea.has_point(get_parent().global_position):
		wrap()

# The parent Node is NOT in wrap area, so it must be wrapped
# around until it is
func wrap():
	# If horizontal wrapping is enabled
	if horizontalWrapping:
		# Wrap by the horizontal axis
		wrapBy(AXIS.HORIZONTAL)
	# If vertical wrapping is enabled
	if verticalWrapping:
		# Wrap by the vertical axis
		wrapBy(AXIS.VERTICAL)

# Function to determine which side of the axis the parent has fallen off
# i.e. the left or right (x axis) or up or down (y axis)
# Return an integer for the direction the wrap is requred in
# the direction is multiplied by the gap (i.e. width or height
# ..and is added to the current axis position
#
# For example:
#   say the screen is 1024 wide
#     zero indexed, so pixels 0 to 1023
#
#   say the sprite has gone off right (at 1024 pixel)
#   We want to subtract 1024 from 1024
#     to position sprite to the left border at 0
# 
# This also work in the opposite direction, for example:
#   say the sprite has gone off left (at pixel -1)
#   We want to add 1024 to the -1
#     to position the sprite to the right border at 1023
#
func getAxisWrapDirection(axis):
	if get_parent().global_position[axis] < wrapArea.position[axis]:
		# off left/top therefore we want to add width or height
		return 1
	elif get_parent().global_position[axis] > wrapArea.size[axis]:
		# off left/top therefore we want to subtract width or height
		return -1
	return 0

# Perform the wrap on the parent object
func wrapBy(axis):
	# Calculate the axis adjustment required
	# I.e. get axis wrap direction and multiply by axis size
	var adjust = getAxisWrapDirection(axis) * wrapArea.size[axis]
	# Apply the adjustment to the parent's position
	get_parent().position[axis] += adjust
