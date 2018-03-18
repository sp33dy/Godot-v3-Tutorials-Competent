extends Node

const VERTLET_BOX = preload("res://VerletBox/VerletBox.tscn")
const PHYSICS_BOX = preload("res://PhysicsBox/PhysicsBox.tscn")

func clear():
	for box in $Boxes.get_children():
		box.queue_free()

func newVerletBox():
	$Boxes.add_child(VERTLET_BOX.instance())

func newPhysicsBox():
	$Boxes.add_child(PHYSICS_BOX.instance())
