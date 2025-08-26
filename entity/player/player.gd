extends Entity

class_name Player

@export var  movement:Movement
@export var state_m:State_manager
@export var ability_manager:Ability_manager
@export var cam:Camera2D

var after_image := Sprite2D.new()
var death_timer := Timer.new()
var dying_anim_tween:Tween
var glow_tween:Tween

func _ready():

	AbilityDefinitions.init_abilities()
	PlayerStats.reset()

	connect_signals_from_Playerstats()
#	PlayerStats.append_ability("blink")
	reset_sprites()

	_on_ground.connect(move,CONNECT_ONE_SHOT)
	death_timer.timeout.connect(die)
	add_child(death_timer)

func _on_morph(_dur):
	PlayerStats.immune = true
	PlayerStats.max_essesence *= 1.3
	PlayerStats.needed_essence_to_morph  *= 1.31
	PlayerStats.reset_jump()
	play_morph_end_anim()

func bounce(y_vel = -800):
	PlayerStats.reset_jump()
	movement.velocity.y = y_vel
	movement.acceleration.y = 20
	state_m.set_state("airborne")

func move():
	PlayerStats.idle = false

func stop_movement():
	state_m.set_enable(false)
	movement.acceleration *= 0
	PlayerStats.idle = true
	create_tween().tween_property(movement,"velocity:x",0.0,1)

func connect_signals_from_Playerstats():
	PlayerStats.dying.connect(_on_dying)
	PlayerStats.recover.connect(_on_recover)
	PlayerStats.morph_start.connect(_on_morph)

func _on_recover():
	if(death_timer.is_stopped()):return
	death_timer.stop()
	state_m.pause(false)
	dying_anim_tween.kill()
	reset_sprites()

func _on_dying():

	if(not death_timer.is_stopped()):return
	play_dying_anim()
	state_m.pause()
	death_timer.start(PlayerStats.dying_duration)

func die():
	if(dead):return
	dead = true
	var shaker = Camera2d_shaker.new()
	if(cam):
		cam.add_child(shaker)
		shaker.shake()
	disable()
	play_die_anim()

func disable(val = true):
	disabled = val
	state_m.pause()
	movement.disable()

func stabilize_y():

	movement.velocity.y = 0
	movement.acceleration.y = 0
####################################################
#anims
func play_morph_end_anim():
	glow(null,3,0.1)
	glow_tween.tween_callback(reset_sprites).set_delay(0.5)

func play_die_anim():
	var img = load("res://entity/assets/glow.png")
	after_image.texture = img
	after_image.material = load("res://materials/additive_sprite.tres")

	$sprites.set_visible(false)
	$shadow_caster.queue_free()

	add_child(after_image)
	var anim_dur = 2
	var final_scale = 100
	var tween = after_image.create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(after_image,"scale",Vector2(final_scale,final_scale),anim_dur/2.0)
	tween.chain().tween_property(after_image,"modulate:a",0.0,anim_dur/2.0)
	tween.tween_interval(2)
	#show game over screen
	tween.tween_callback(func ():PlayerStats.emit_signal("game_over"))

func reset_sprites():
	get_node("sprites").scale = Vector2.ONE
	if(glow_tween):glow_tween.kill()
	glow(null,0,0.4)

func play_dying_anim():
	glow(null,3,PlayerStats.dying_duration)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_loops()
	tween.tween_property(get_node("sprites"),"scale",Vector2.ONE*1.3,0.01)
	tween.tween_property(get_node("sprites"),"scale",Vector2.ONE,0.01)
	dying_anim_tween = tween

func glow(from = null,to:float = 3,dur:float = 0):
	glow_tween = create_tween()
#	glow_tween.set_ease(Tween.EASE_OUT)

	if(from == null):
		from = %Glow.material.get_shader_parameter("brightness")

	glow_tween.tween_method(func(brightness):
		%Glow.material.set_shader_parameter("brightness",brightness)
	,from,to,dur)
	return glow_tween

####################################################

func _on_platform_sensor_body_entered(_body):
	PlayerStats.jumps_remaining = PlayerStats.max_jumps
	grounded = true

func _on_platform_sensor_body_exited(_body):
	grounded = false

#set essence target
func _on_essence_sensor_body_entered(essence:Essence):
	if(essence.claimed):return
	essence.set_target(%Eye_Trail)

#follow
func _on_essence_sensor_body_exited(essence:Essence):
	essence.start_follow()

#consume
func _on_in_essence_sensor_body_entered(essence:Essence):
	if(not essence.claimed):return
	essence.play_desolve_anim()

	if(dead or false):return
	var j_remain = PlayerStats.jumps_remaining
	PlayerStats.update_essence(PlayerStats.essence_gain_per_claim)
	PlayerStats.jumps_remaining = 1 if j_remain < 1 else j_remain

func _on_visible_on_screen_notifier_2d_screen_exited():
	if(global_position.y < 700):return
	die()
