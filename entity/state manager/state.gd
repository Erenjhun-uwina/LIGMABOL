extends Node

class_name State

@onready var state_m:State_manager = get_parent()
var entity:Entity

func _ready():
	#get the player node
	entity = state_m.entity
	entity_ready()

func entity_ready():
	pass


func _on_enter():
	pass

func _on_exit():
	pass

func _transition_to(state:String,condition:bool = true):
	if(condition):state_m.call_deferred("set_state",state)

func cancel():
	state_m.return_prev_state()

func unhandled_input(_event):
	pass

func physics_process(_delta):
	pass
