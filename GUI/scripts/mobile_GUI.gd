extends Control

signal l_b_press
signal r_b_press
var jump_action :InputEventAction = InputEventAction.new()
var dive_action := InputEventAction.new()



func _ready():
	jump_action.action = "jump"
	dive_action.action = "dive"
	

func _on_dive_pressed():
	press_action(dive_action)
	print("dive")

func _on_dive_released():
	press_action(dive_action,false)

func _on_jump_pressed():
	press_action(jump_action)
	print("jump")

func _on_jump_released():
	press_action(jump_action,false)

func press_action(action,is_pressed = true):
	action.pressed = is_pressed
	Input.parse_input_event(action)
