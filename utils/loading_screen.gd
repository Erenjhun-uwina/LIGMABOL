extends Node

@export var label:Label
@export  var bg:Marker2D
@export var loader:Loader

@export_file var main_scene:String
@export_file var menu_scene:String




@onready var to_load:Array[String] = [
	main_scene,
	menu_scene
]

var scenes

var bg_final_y_pos

func _ready():
	bg_final_y_pos = bg.position.y
	bg.position.y = 0
	loader.connect("finish",on_finish)
	loader.connect("progress",on_progress)
	loader.load_resources(to_load)

func on_progress(p):
	var progress:float = p as float

	var tween:Tween = label.create_tween()
	tween.set_parallel()
	tween.tween_property(bg,"position:y",progress * bg_final_y_pos,0.5).set_ease(Tween.EASE_OUT)
	tween.tween_method(set_label, float(label.get_text().rstrip("%")), progress*100,0.1)


func on_finish(resources):

	scenes = resources
	set_scene_refs()

	var glow = $%eye_glow
	var tween:Tween = glow.create_tween()

	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(glow,"scale",Vector2(35,35),2)
	tween.tween_callback(transition)
	$sprites.tween.kill()

func set_label(progress:float):
	label.set_text("%.2f"%progress+"%")

func transition():
	get_tree().change_scene_to_packed(SceneRefs.menu)

func set_scene_refs():
	SceneRefs.main_level = scenes[0]
	SceneRefs.menu = scenes[1]
