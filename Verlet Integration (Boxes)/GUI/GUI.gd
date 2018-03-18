extends Node2D

func _on_Clear_pressed():
	get_parent().clear()

func _on_New_Verlet_Box_pressed():
	get_parent().newVerletBox()

func _on_New_Godot_Box_pressed():
	get_parent().newPhysicsBox()
