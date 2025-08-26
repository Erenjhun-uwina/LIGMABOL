extends State

func _on_enter():
	var movement:Movement = entity.get_node("Movement")
	movement.velocity.x = 600

func unhandled_input(event:InputEvent):
	_transition_to("trick",event.is_pressed())
