extends Node

class_name State_manager

@export var entity:Entity = get_parent()
@export var curr_state:State
var prev_state:State
var paused = false

func _ready():
	entity.ready.connect(init)


func init():
	set_state(curr_state.name)

func _physics_process(delta):
	curr_state.physics_process(delta)


func set_state(state:String):
	
	#run current state's _on_exit before replacing
	curr_state._on_exit()
	prev_state = curr_state
	#run _on_enter after replacing
	curr_state = get_node(state)
	curr_state._on_enter()

func return_prev_state():
	curr_state = prev_state
	prev_state = curr_state    

func pause(val = true):
	paused = val
	var mode =   Node.PROCESS_MODE_DISABLED if (val) else Node.PROCESS_MODE_INHERIT
	set_process_mode(mode)

func _unhandled_input(event):
	curr_state.unhandled_input(event)

func set_enable(enable = true):
	set_process_unhandled_key_input(enable)
