extends Marker2D

class_name _Area

@export var platforms:Platforms
@onready var v_notifier:VisibleOnScreenNotifier2D = %v_notifier
@onready var cam = get_tree().root.get_camera_2d()

var width
var end_position:get = get_end_position

var spawn_next = false
signal enter_viewport


func _ready():
	width = platforms.width
	resize_v_notifier()
	set_process(false)

func resize_v_notifier():
	v_notifier.scale = Vector2.ONE

	v_notifier.transform = Transform2D(0,Vector2(0,324))
	v_notifier.rect = Rect2( Vector2.ZERO, Vector2(width,64))

func _process(_delta):
	var dist_to_cam = global_position.x+width  -  cam.global_position.x
	if(abs(dist_to_cam) > 1500):
		queue_free()

func get_end_position():
	return position.x + width

func _on_visible_on_screen_notifier_2d_screen_entered():
	if(spawn_next):return
	spawn_next = true
	emit_signal("enter_viewport")

func _on_visible_on_screen_notifier_2d_screen_exited():
	set_process(true)
