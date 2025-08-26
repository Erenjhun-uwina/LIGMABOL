extends Ability

class_name Dash_ability


var duration:float = 0.15
var deact_delay:float = 0.05

var trail
var eye_trail
var last_x_vel

var stop_timer:Timer
var cd_timer:Timer
var deact_timer:Timer

var max_speed:float = 600

func _init():
	super("dash",["dash in a short direction"],["dash1"])
	cost = 5


func _on_set_entity():
	trail = entity.get_node("%Trail")
	eye_trail = entity.get_node("%Eye_Trail")
	set_up_timers()

func cast():
	if(not avail):
		finish.emit()
		return 

	last_x_vel = entity.movement.velocity.x
	entity.movement.velocity = Vector2(3200,0)
	entity.stabilize_y()

	if(trail):
		trail.active = true
		eye_trail.active = true

	stop_timer.start(duration)
	cd_timer.start(cd)
	avail = false

func process():
	entity.stabilize_y()

func stop():
	
	entity.movement.velocity.x =  min(last_x_vel + 50,max_speed)
	finish.emit()
	#stop the trail
	if(trail):
		deact_timer.start(deact_delay)

func deact_trail():
	trail.deact()
	eye_trail.deact()

func set_up_timers():
	
	stop_timer = Timer.new()
	cd_timer = Timer.new()
	deact_timer = Timer.new()
	
	stop_timer.timeout.connect(stop)
	cd_timer.timeout.connect(on_cd)
	deact_timer.timeout.connect(deact_trail)
	
	stop_timer.one_shot = true
	cd_timer.one_shot = true
	deact_timer.one_shot = true
	
	entity.add_child(stop_timer)
	entity.add_child(cd_timer)
	entity.add_child(deact_timer)
