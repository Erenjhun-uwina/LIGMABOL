extends Area2D

class_name Platform_detector
var parent:Entity

func _ready():
	parent = get_parent()
#
	body_entered.connect(func (_bod):
		parent.grounded = true
	)


	body_exited.connect(func (_bod):
		parent.grounded = false
	)
