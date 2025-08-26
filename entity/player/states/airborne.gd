extends State



func physics_process(_delta):
	if(entity.movement.velocity.y > 0):
		return _transition_to("falling")


func unhandled_input(_event):
	_transition_to("casting_ability",Input.is_action_pressed("cast_ability"))
	_transition_to("diving",Input.is_action_pressed("dive"))
	_transition_to("jumping",Input.is_action_just_pressed("jump"))
