extends Node
class_name Loader

var finished = false
var paths = []
var curr_path_in_progress
var to_load
var loaded:int = 0
var resources = []

signal finish
signal progress


func _ready():
	set_process(false)


func is_finish():
	
	loaded+=1
	
	if(loaded == to_load):
		finished = true
		set_process(false)
		emit_signal("finish",resources)
		return
	
	start_load()
	
	

func _process(_delta):
	var prog = []
	var status = ResourceLoader.load_threaded_get_status(curr_path_in_progress,prog)
	
	emit_signal("progress",prog[0]+loaded/to_load as float)
	if(status == ResourceLoader.THREAD_LOAD_LOADED):
		var resource = ResourceLoader.load_threaded_get(curr_path_in_progress)
		resources.append(resource)
		is_finish()

func  load_resource(path):
	paths.append(path)
	start_load()

func load_resources(paths:Array[String]):
	self.paths = paths
	to_load = paths.size()
	start_load()

func start_load():
	curr_path_in_progress = paths.pop_front()
	ResourceLoader.load_threaded_request(curr_path_in_progress)
	set_process(true)
