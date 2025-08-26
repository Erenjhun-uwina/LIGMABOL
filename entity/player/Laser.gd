extends RayCast2D

class_name Laser

var length = 1115
var max_width = 30.0

@export var texture:TextureRect
@export var glow_text:CompressedTexture2D


func _ready():
	target_position = Vector2(length,0)
	texture.position.y = - max_width/2
	texture.pivot_offset.y = max_width/2
	texture.size.y = max_width
	texture.scale.y = 0

func _physics_process(_delta):
	if(is_colliding()):
		var x_pos  = global_position.distance_to(get_collision_point())
		update_laser_end(x_pos)

		var target = get_collider().get_parent()

		if(target.name) != "platforms":

			kill_target(target)
			pass
	else:
		update_laser_end(length)

func kill_target(target):

	if(target.dead):return

	var glow: = Sprite2D.new()
	glow.texture = glow_text
	glow.global_position = target.global_position

	target.dead = true
	target.queue_free()

	get_tree().root.get_node("v_con/%level").add_child(glow)

	var tween = glow.create_tween()
	tween.tween_property(glow,"scale",Vector2(3,3),0.1)
	tween.tween_property(glow,"modulate:a",0.0,2.5)

func fire():
	enabled = true
	texture.scale.y = 0
	var on_tween:= create_tween()
	on_tween.tween_property(texture,"scale:y",1.0,0.2)

func disable():
	var off_tween:= create_tween()
	off_tween.tween_property(texture,"scale:y",0.0,0.1)
	off_tween.tween_callback(func():enabled = false)

func update_laser_end(x_pos:float):
	texture.size.x = x_pos * 0.93
