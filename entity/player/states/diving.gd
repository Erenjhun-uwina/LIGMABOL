extends State

var trail
var eye_trail
var movement

func _on_enter():
	if(entity.grounded):return cancel()
	movement.velocity.y = 3200
	trail.active = true
	eye_trail.active = true
	
	if(!entity.is_connected("_on_ground",_transition_to)):
		entity.connect("_on_ground",_transition_to.bind("default"), CONNECT_ONE_SHOT)
	

func _on_exit():
	if(entity.is_connected("_on_ground", _transition_to)):
		entity.disconnect("_on_ground", _transition_to)
	
	PlayerStats.essence -= PlayerStats.diving_cost
	
	trail.deact(0.3)
	eye_trail.deact(0.3)

func unhandled_input(_event):
	_transition_to("jumping",Input.is_action_just_pressed("jump"))
	_transition_to("casting_ability",Input.is_action_pressed("cast_ability"))

func entity_ready():
	trail = entity.get_node("%Trail")
	eye_trail =  entity.get_node("%Eye_Trail")
	movement = entity.get_node("%Movement")
