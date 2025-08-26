extends Node2D

class_name Level

@onready var player = get_node("bol")
@onready var movement:Movement


func get_areas():
	var areas:Array[_Area] = []

	for area in get_children():

		if(area is _Area):
			areas.append(area)
	return areas

func _ready():
	SoundManager.play_bg()
	setup_inputs()
	movement = player.get_node("Movement")
	movement.velocity.x = 1000 #little boost from the start
	await $/root/v_con/%Screen_fader.fade_out(0.6).fade_out_finish
	movement.velocity.x = PlayerStats.max_speed


func _process(_delta):
	accelerate_player()
	PlayerStats._on_set_dist.emit(int(player.global_position.x/100))

func _unhandled_input(event:InputEvent):

	if(event.get_class() == "InputEventKey" and event.keycode == KEY_2):
		PlayerStats.essence+=10

	if(event.get_class() == "InputEventKey" and event.keycode == KEY_M):
		PlayerStats.morph()

	if(event.get_class() == "InputEventKey" and event.keycode == KEY_1):
		player.call_deferred("die")

	if(event.get_class() == "InputEventKey" and event.keycode == KEY_Q):
		PlayerStats.max_speed = min(PlayerStats.max_speed+100,600)
		player.get_node("Movement").velocity.x = min(PlayerStats.max_speed+100,700)

	if(event.get_class() == "InputEventKey" and event.keycode == KEY_E):
		PlayerStats.max_speed = max(PlayerStats.max_speed-100,0)
		player.get_node("Movement").velocity.x = max(PlayerStats.max_speed-100,0)

#accelerate the player if speed is less than max speed  else stop acceleration
func accelerate_player():
	if(not is_instance_valid(movement)):return
	movement.acceleration.x = PlayerStats.acceleration if (not PlayerStats.idle and movement.velocity.x < PlayerStats.max_speed) else 0.0


func setup_inputs():

	add_input_actions("jump",[KEY_SPACE,KEY_W,KEY_UP])
	add_input_actions("dive",[KEY_D,KEY_DOWN])
	add_input_actions("cast_ability",[KEY_P,KEY_R])


func add_input_actions(action_name:String,action_keys:Array[int]):
	if(!InputMap.has_action(action_name) ):
		InputMap.add_action(action_name)

	for key in action_keys:
		_add_input_action(action_name,key)


func _add_input_action(action_name:String,action_key:int):
	var ev = InputEventKey.new()
	ev.keycode = action_key
	InputMap.action_add_event(action_name,ev)
