extends Marker2D


class_name Trail

@onready var line:Line2D = $Line2D
var width = 0 
var length = 20
var active = false 
var ctimer:Timer

func _physics_process(_delta):
	
	line.global_position = Vector2.ZERO
	line.add_point(global_position)
	
	
	if(active):
		if(line.get_point_count() > length):line.remove_point(0)
	else:
		if(line.get_point_count() > 1 ):
			line.remove_point(0)
			line.remove_point(0)


func deact(offset:float = 0):
	
	if(offset <= 0): return _deact()
	var ctimer = get_tree().create_timer(offset)
	ctimer.timeout.connect(_deact,CONNECT_ONE_SHOT)

func _deact():
	active = false
