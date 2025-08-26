extends Node

class_name Camera2d_shaker

signal finish

var cam:Camera2D
var tree:SceneTree
var _orig_offset:Vector2

var shaking = false
var strength
var duration
var delete_on_finish = false


func _init(strength:int = 50,duration:float = 0.3):
	self.strength = strength
	self.duration = duration

func _ready():
	cam = get_parent()
	tree = cam.get_tree()
	_orig_offset = cam.offset
	disable_unneccesary_proccess()

func _process(_delta):
	var offs = _orig_offset + Vector2(randf(),randf())*strength
	cam.set_offset(offs)

func shake(duration:float = self.duration):
	set_process(true)
	shaking = true
	tree.create_timer(duration).connect("timeout", on_finish)

func on_finish():
	if(!shaking):return
	set_process(false)
	shaking = false
	cam.set_offset(_orig_offset)
	emit_signal("finish")
	if(delete_on_finish):queue_free()

func disable_unneccesary_proccess():
	set_physics_process(false)
	set_process(false)
	pass
