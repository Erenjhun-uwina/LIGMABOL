extends Dash_ability

class_name Headbutt_ability


func _init():
	super()
	title = "headbutt"
	descs = ["dash in a short direction "]
	textures = ["recover"]
	cd = 1
	cost = 10

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
