extends Sprite

const CHAIN_LOOP_GAP = 2

export var anchor = false

var over = false

var pos = Vector2()
var oldPos = Vector2()

func setPosition(index):
	pos = Vector2(0, index + 1) 
	pos *= (texture.get_size().y + CHAIN_LOOP_GAP)
	oldPos = pos
	position = pos

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and over:
		var mousePos = get_viewport().get_mouse_position()
		var vector = mousePos - global_position
		oldPos = pos
		pos += vector

func _on_Control_mouse_entered():
	if !anchor:
		over = true
		modulate = Color(0x0000ffff)

func _on_Control_mouse_exited():
	if !anchor:
		over = false
		modulate = Color(0xffffffff)
