extends Entity

class_name Ted

var spd = 60
var dir = 1
const dmg = 20
var bounced = false
var active = true

var essense  =  preload("res://entity/essence.tscn")

func _ready():
	dir = scale.x
	set_physics_process(false)
	await get_tree().create_timer(0.2).timeout
	set_physics_process(true)
	await get_tree().create_timer(randf() * 0.5).timeout
	move()

func set_vel(x):
	if(dead):return
	$Movement.velocity.x = x

func move():
	if(bounced or not active):return
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("default")

	var tween = create_tween()

	tween.tween_interval(0.5)
	tween.tween_callback(Callable(self, "set_vel").bind(dir*spd))


	tween.tween_interval(0.5)
	tween.tween_callback(Callable(self, "set_vel").bind(0))


	tween.tween_interval(0.1)
	tween.tween_callback(Callable(self, "move"))

func _physics_process(_delta):

	var not_in_edge = $platform_cast.is_colliding() or $Movement.velocity.y > 16
	var front_clear = not ($front_cast.is_colliding() and $front_cast)

	if(not_in_edge and front_clear):return

	dir *= -1
	scale.x *= -1
	$Movement.velocity.x = 0
	$AnimatedSprite2D.frame = 3
func splat():
	dead = true
	$AnimatedSprite2D.play("splat")
	$Movement.velocity.x = 0
	var ins = essense.instantiate()
	ins.position = position
	get_parent().call_deferred("add_child",ins)

func _on_player_detector_area_entered(area: Area2D) -> void:

	var player:Player = area.get_parent()

	if(bounced):return

	var p_state:String = player.state_m.curr_state.name

	if(p_state == "falling" or p_state == "diving"):
		bounced = true
		player.position.y = player.global_position.y-70
		player.bounce()
		splat()
		return

	player.movement.velocity.x = max(0,player.movement.velocity.x-100)
	PlayerStats.essence -= dmg
