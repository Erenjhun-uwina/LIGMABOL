extends CharacterBody2D

class_name Essence

var grounded = false
var claimed = false

var speed:float = 600
var active = true

var target
var tween
var disabled = false

func _ready():
#	$Gravity2d.disable()
	jump()
	set_physics_process(false)
	twinkle()

func _physics_process(_delta):
	follow()

func jump():
	if(claimed):return
	var tween:= create_tween()
	$Movement.velocity.y = -10
	$Movement.acceleration.y = 0
	tween.tween_interval(randf() * 0.5 + 0.5)
	tween.tween_callback(jump)

func twinkle():
	tween = create_tween()
	var alpha:float = 0 if (not claimed and $glow.modulate.a > 0) else 1
	var dur = randf() if (not claimed) else 0.0

	tween.tween_property($glow,"modulate:a",alpha,dur)
	if(not claimed):tween.tween_callback(twinkle)

func set_target(_target):
	if(target != null or not active):return
	claimed = true
	disabled = true
	target = _target

	$Movement.acceleration = Vector2.ZERO
	$Gravity2d.disable()

	var tween = create_tween()
	var final_speed:float = PlayerStats.max_speed*3

	tween.set_parallel()
	tween.tween_property(self,"speed",final_speed,5)

func follow():
	if(not active):return
	var dir:Vector2 = target.global_position - global_position
	dir  = dir.normalized()
	dir *= speed
	$Movement.velocity = dir


func play_desolve_anim():

	active = false
	$AnimatedSprite2D.visible = false
	$glow.modulate.a = 1

	if(tween != null):tween.kill()

	var tween:= create_tween()
	tween.set_parallel()
	tween.tween_property($glow,"scale",Vector2.ONE*3,0.3)
	tween.tween_interval(0.3)

	$Movement.velocity = Vector2.ZERO
	global_position = target.global_position
	tween.chain().tween_property($glow,"modulate:a",0.0,1)
	tween.chain().tween_callback(queue_free)

func start_follow():
	set_physics_process(true)
