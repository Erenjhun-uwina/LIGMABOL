extends Node

class_name  Ability_manager


@export_node_path("Player") var player

var abilities:Array[Ability]:get = get_abilities,set = set_abilities
var _curr_ability_ind:get = get_curr_ability_ind ,set = set_curr_ability_ind

func get_abilities()->Array[Ability]:return PlayerStats.abilities
func get_curr_ability_ind()->int:return PlayerStats._curr_ability_ind



func _ready():
	PlayerStats.ability_added.connect(
		func(ability:Ability):
			ability.entity = get_node(player)
	)

func cast_ability(c_acbility:Ability)->void:
	
	##cast the current ability
	c_acbility.cast()
	
	##then increment the curr ability index
	var next = _curr_ability_ind+1 
	_curr_ability_ind = 0 if ( next >= abilities.size() ) else next
	PlayerStats.ability_cast.emit(_curr_ability_ind)

func curr_ability()->Ability:
	if(abilities.size()<1):
		print("you have no abilities")
		return null
	return abilities[_curr_ability_ind]

func  set_abilities(val:Array[Ability]):
	PlayerStats.abilities = val
	
func set_curr_ability_ind(val):
	PlayerStats._curr_ability_ind = val
