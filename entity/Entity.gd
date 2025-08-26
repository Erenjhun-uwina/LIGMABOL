extends CharacterBody2D

class_name Entity


signal _on_ground
signal _off_ground
signal on_disable


var hp:float= 1
var dead:bool = false
var grounded:bool = false :set = set_grounded
var disabled:bool = false :set = set_disabled

func set_disabled(val):
	disabled = val
	if(disabled):on_disable.emit()

func set_grounded(val):
	grounded = val
	var _signal:Signal = _on_ground if val else _off_ground
	_signal.emit()
