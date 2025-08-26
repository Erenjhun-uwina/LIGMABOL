extends Node

class_name Movement

var velocity = Vector2.ZERO
var acceleration = Vector2(0,0)
@export var body:CharacterBody2D
signal update

func set_velocity(x=0,y=0)->void:
	if(typeof(x) == TYPE_VECTOR2):
		velocity = x
		return
	velocity.x = x
	velocity.y = y

func _physics_process(delta):
	emit_signal("update")
	update_pos(delta)

func update_pos(delta):
	velocity += acceleration
	body.set_velocity(velocity*delta*60)
	body.move_and_slide()
	velocity = body.velocity
	if(body.grounded):acceleration.y *= 0

func disable():
	set_physics_process(false)
