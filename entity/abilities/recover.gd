extends Ability

class_name Recover_ability

var movement:Movement
var fader:Screen_fader


func _init():
	super("recover",
	["jump,recover essence,cleanse all crowd controls and resets jump stamina"],
	["recover"]
	)
	cd = 5
	cost = -20
	spammable = false

func _on_set_entity():
	movement = entity.get_node("%Movement")
	fader = entity.get_node("/root/v_con/%Screen_fader")

func cast():
	#jump
	movement.acceleration.y = 0
	movement.velocity.y = -800

	#reset canjump removes grounded(cannot jump)
	PlayerStats.reset_jump()

	#cancelss the blind overlay
	fader.cancel_all()
	fader.fade_out(0.1)
