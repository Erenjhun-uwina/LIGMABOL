extends State




func _on_enter():
	
	if(not PlayerStats.can_jump):return cancel()
	var movement = entity.movement
	
	movement.acceleration.y = 0
	movement.velocity.y = -800
	PlayerStats.jumps_remaining -= 1
	PlayerStats.essence -= PlayerStats.jump_cost
	_transition_to("airborne")
	

