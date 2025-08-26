extends Ability

class_name Laser_ability
var laser:Laser
const duration:float = 0.2
var stop_timer: Timer

func _init():
	super("laser",["Fires a laser that obliterates enemies"],["laser"])
	cost = 10

func _on_set_entity():
	stop_timer = Timer.new()
	stop_timer.timeout.connect(stop)
	stop_timer.one_shot = true
	laser = entity.get_node("%Laser")
	entity.add_child(stop_timer)

func cast():
	entity.stabilize_y()
	laser.fire()
	stop_timer.start(duration)

func process():
	entity.stabilize_y()

func stop():
	finish.emit()
	laser.disable()
