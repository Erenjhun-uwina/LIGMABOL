extends State

var c_acbility:Ability
var movement 
signal trick


func _on_enter():
	emit_signal("trick")
	jump()
	$%main_cam.set_process_mode(Node.PROCESS_MODE_DISABLED)
	entity.connect("_on_ground",dash)

func physics_process(_delta):
	if(c_acbility == null):return
	if(c_acbility.has_method("process")):c_acbility.process()

func jump():
	movement = entity.get_node("Movement")
	entity.stabilize_y()
	movement.velocity.y = -800

func dash():
	c_acbility  = Dash_ability.new()
	c_acbility.entity = entity
	c_acbility.cast()
