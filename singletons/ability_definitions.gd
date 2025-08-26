extends Node


var definitions:Array[Ability] 



func init_abilities():
	
	definitions = [
		Dash_ability.new(),
		Laser_ability.new(),
		Blast_ability.new(),
#		Headbutt_ability.new(),
		Blink_ability.new(),
		Smash_ability.new(),
		Recover_ability.new()
	]
	
	
	
