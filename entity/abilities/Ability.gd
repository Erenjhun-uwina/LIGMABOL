extends Object

class_name Ability

var entity:Entity :set = set_entity
var cancellable = false: get = get_cancellable
var spammable = true
var avail:bool = true
var cost:float = 0.0
var cd:float = 0

var rank:int = 1
var max_rank:int = 1

var title:String = ""
var desc:String = "" :get = get_desc


var descs:Array = [""]
var textures:Array = ["blank"]
var finished = true

# warning-ignore:unused_signal
signal finish
signal entity_set


func get_node(path:NodePath):
	return entity.get_node(path)

func _on_set_entity():
	pass

func set_entity(in_entity:Entity):
	entity = in_entity
	entity_set.emit()

func get_texture():
	return textures[rank-1] + ".png"

func get_desc()->String:
	return descs[rank-1]

func cast():
	pass

func get_cancellable()->bool:
	return true

func _init(in_title="",in_descs=[""],in_textures=["blank"]):
	title = in_title
	descs = in_descs
	textures = in_textures
	entity_set.connect(_on_set_entity)

func get_cast()->Callable:
	return func():return

func on_cd():
	avail = true
