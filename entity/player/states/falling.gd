extends default_state

class_name  Falling

func _ready():
	super._ready()
	entity._on_ground.connect(_transition_to.bind("default"))

func unhandled_input(_event):
	_transition_to("casting_ability",Input.is_action_pressed("cast_ability"))
	_transition_to("diving",Input.is_action_pressed("dive"))
	_transition_to("jumping",Input.is_action_just_pressed("jump"))


func physics_process(_delta):
	pass
