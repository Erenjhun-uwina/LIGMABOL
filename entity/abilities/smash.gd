extends Ability

class_name Smash_ability

var movement:Movement
var trail:Trail
var eye_trail:Trail

func _init():
	super("Smash",
	["Smahes the ground disabling all trap entities.Has a chance to extract essence from them"],
	["smash"]
	)
	cd = 5
	spammable = false

func _on_set_entity():
	movement = entity.get_node("%Movement")
	trail = entity.get_node("%Trail")
	eye_trail =  entity.get_node("%Eye_Trail")
	entity._on_ground.connect(
		func():
			trail.deact(0.3)
			eye_trail.deact(0.3)
	)

func cast():
	movement.velocity.y = 3200
	trail.active = true
	eye_trail.active = true
	finish.emit()
