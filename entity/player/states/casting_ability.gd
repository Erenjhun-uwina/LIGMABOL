extends State

class_name Casting_ability

@export_node_path("Ability_manager") var ability_manager_path
@onready var ability_manager = get_node(ability_manager_path)

var cd_timer:Timer = Timer.new()
var c_acbility:Ability

func _ready():
	super._ready()
	cd_timer.one_shot = true
	add_child(cd_timer)
	
func _on_enter():
	c_acbility = ability_manager.curr_ability()

	if(c_acbility == null or (not c_acbility.finished and not c_acbility.spammable)):
		stop()
		return
	
	#as a remembrance of my idiocracy I leave this comment here
	#I am wondering why the signal is not emitting 
	#Well it is actually emitting but it is emitted before connecting to it so its useless
	
#	entity.cast_ability(c_acbility)
#	c_acbility.connect("finish",self,"stop",[],CONNECT_ONESHOT)
# 	what a fucker
	
	if(not c_acbility.finish.is_connected(stop)):
		c_acbility.finish.connect(stop,CONNECT_ONE_SHOT)
	
	cd_timer.start(c_acbility.cd)
	ability_manager.cast_ability(c_acbility)
	PlayerStats.update_essence(-c_acbility.cost)

func stop():
	_transition_to("default")

func unhandled_input(_event):

	if(not c_acbility.cancellable): 
		print("not cancellable bitch")
		return
	_transition_to("diving",Input.is_action_pressed("dive"))
	_transition_to("jumping",Input.is_action_just_pressed("jump"))
	_transition_to("casting_ability",Input.is_action_just_pressed("cast_ability"))

func physics_process(_delta):
	if(c_acbility.has_method("process")):c_acbility.process()
