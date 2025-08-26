extends CPUParticles2D

@onready var cam = get_node("../bol/main_cam")
var run = true
var x_off

func  _ready():
	x_off = cam.global_position.x - global_position.x


func _process(_delta):

	if(not run):return
	if(not is_instance_valid(cam)): 
		run =false
		return
		
	global_position.x = cam.global_position.x - x_off


