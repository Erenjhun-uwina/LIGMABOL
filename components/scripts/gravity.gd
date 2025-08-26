extends Node

class_name Gravity2d

@export var strength = 16.0
@export var mass = 1
@export var movement:Movement 

func  _ready():
	movement.connect("update",apply)


func apply()->void:
	if(movement.acceleration.y > 30):return
	movement.acceleration.y += strength

func disable()->void:
	set_physics_process(false)

func enable()->void:
	set_physics_process(true)
