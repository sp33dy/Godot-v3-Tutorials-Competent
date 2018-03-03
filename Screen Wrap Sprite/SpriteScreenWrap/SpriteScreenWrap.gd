extends Sprite

# Declare three Axis types
const AXIS = {
	HORIZONTAL = "x",
	VERTICAL = "y",
	BOTH = "x&y"
}

# Expect the area to be defined in the Inspector Tool
# i.e. this might be the screen resolution, say 1024 x 600 starting at 0 x 0
export (Rect2) var wrapArea = null

# Expect configuration in the tool as to whether horizontal and/or vertical 
# wrapping is required; i.e. this can be kept to only Horizontal for example 
export (bool) var horizontalWrap = true setget setHorizontalWrap
export (bool) var verticalWrap = true setget setVerticalWrap

# Two pre-calculated sizes to reduce computations
var spriteSize
var halfSpriteSize

# If the horizontal flag is set, action the decision
func setHorizontalWrap(flag):
	horizontalWrap = flag
	if !flag:
		removeMirror(AXIS.HORIZONTAL)

# If the vertical flag is set, action the decision
func setVerticalWrap(flag):
	verticalWrap = flag
	if !flag:
		removeMirror(AXIS.VERTICAL)

# When the Sprite is in the scene tree and ready, calculate the sprite size
# and half of it. I use two member variables here as I only wanted to calculate
# this once. However, if you need to change the texture, you'd need to recalculate
# these values!
func _ready():
	spriteSize = get_texture().get_size() * scale
	halfSpriteSize = spriteSize / 2

# Define the process to process the wrap on this Sprite, every frame
#
# Unfortunately, I would like to extend the Sprite Class and override the
# position variable or set_position function, but currently, Godot Engine
# does not allow it. So, instead of only wrapping when the Sprite is moved,
# we are forced to check EVERY frame; which requires more calculations!
func _process(delta):
	# Only wrap if an area is defined otherwise stop all processing
	if wrapArea != null:
		wrapHorizontally()
		wrapVertically()
		checkForHorizontalAndVerticalWrap()
	else:
		set_process(false)

# Check whether Horizontal wrapping is configured and do it!
func wrapHorizontally():
	if horizontalWrap:
		applyWrap(AXIS.HORIZONTAL)

# Check whether vertical wrapping is configured and do it!
func wrapVertically():
	if verticalWrap:
		applyWrap(AXIS.VERTICAL)

# Check whether the 'special case' is detected. I.E. If the sprite is
# to be wrapped horizontally and vertically, IT MUST be in the corner, 
# therefore we MUST add the third diagnal corner!
func checkForHorizontalAndVerticalWrap():
	if has_node(AXIS.HORIZONTAL) && has_node(AXIS.VERTICAL):
		addMirrorForBothAxis()
	else:
		removeMirror(AXIS.BOTH)

# This looks more complicated than it actually is!
#
# We need to check, in turn, the two borders of the axis provided.
#  i.e. horizontal would be left and right, vertical would be top and bottom
#
# However, we need to check for two cases on each border
#
# 1. If the Sprite has started to wrap, then we need to create a copy
# 2. If the Sprite has gone off screen (completed wrapping), then we need to
#    remove the copy and reposition the Sprite over the copy
#
# NOTE: this function ASSUMES the sprite is centrally positioned! You will need
#       to adjust the code if that is not desirable
#
# NOTE2: The order of the conditional statements are in the specific order coded
#        because we want to stop the searching as soon as one of the conditions
#        are met. If you swap the first two conditions around, we'd never go off
#        the left hand-side, because the start to wrap would always be true!
func applyWrap(axis):
	# Check if the Sprite has gone off the screen (left or top)
	if global_position[axis] <= wrapArea.position[axis] - halfSpriteSize[axis]:
		completeWrap(axis, wrapArea.size[axis])
	# Check if the Sprite has started to wrap (left or top)
	elif global_position[axis] <= wrapArea.position[axis] + halfSpriteSize[axis]:
		mirrorWrap(axis, wrapArea.size[axis])
	# Check if the Sprite has gone off the screen (right or bottom)
	elif global_position[axis] >= wrapArea.size[axis] + halfSpriteSize[axis]:
		completeWrap(axis, -wrapArea.size[axis])
	# Check if the Sprite has started to wrap (right or bottom)
	elif global_position[axis] >= wrapArea.size[axis] - halfSpriteSize[axis]:
		mirrorWrap(axis, -wrapArea.size[axis])

# Move the Sprite to the opposite side and delete of the copy 
func completeWrap(axis, gap):
	position[axis] += gap
	removeMirror(axis)

# If the copy doesn't already exist (we use the node name as 'axis') then
# create a mirror copy of this Sprite and add it as a child! A child, so that
# we can look it up and only ever have THREE children per Sprite! 
# i.e. Horizontal, Vertical and Diagnal copies!
func mirrorWrap(axis, gap):
	if !has_node(axis):
		var mirrorOffset = Vector2(0, 0)
		mirrorOffset[axis] = gap
		addMirror(axis, mirrorOffset)

# Make a copy of the Sprite and add it as a child
# Because it is to be a child, set the position to 0 x 0 and use the offset
# to positon it! By doing this, as the Sprite moves, so will it's child, 
# thereby making the copy to move in synch to it!
#
# Note: The name is important, because we use it to determine if it already
#       exists and for removing it too!
func addMirror(axis, mirrorOffset):
	var mirrorSprite = Sprite.new()
	mirrorSprite.name = axis
	mirrorSprite.texture = texture
	mirrorSprite.position = Vector2(0, 0)
	mirrorSprite.offset = mirrorOffset
	add_child(mirrorSprite)

# The special case to create the copy in a diagnal of the Sprite, if both
# Horizontal and Vertical positions are set.
# 
# Create an empty Vector2 and then copy in both the Horizontal and Vertical
# offsets, by doing so, you end up with the opposite corner! The beauty of
# mathematics.
func addMirrorForBothAxis():
	if !has_node(AXIS.BOTH):
		var mirrorOffset = Vector2(0, 0)
		mirrorOffset = get_node(AXIS.HORIZONTAL).offset
		mirrorOffset += get_node(AXIS.VERTICAL).offset
		addMirror(AXIS.BOTH, mirrorOffset)

# Finally, remove the node if it is a child 
func removeMirror(axis):
	if has_node(axis):
		get_node(axis).queue_free()
