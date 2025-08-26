@tool
extends Node2D

class_name Platforms

@export var width:int = 0


func _ready():
	calc_width()

func calc_width():
	var last_p = find_last_platform()

	width = last_p.width + last_p.position.x

	return width



func find_last_platform()->Platform:

	var last_p


	for platform in get_children():

		if(last_p == null):last_p = platform;continue

		var last_p_w = last_p.width + last_p.position.x
		var p_w = platform.width + platform.position.x

		if(last_p_w < p_w):
			last_p = platform

	if(not last_p):
		last_p = Platform.new()
		last_p.width = 0

	return last_p
