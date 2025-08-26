extends Node

class_name Area_spawner

@onready var level = get_parent()
@export var area_1:_Area

var area_indx = 0
var last_area:_Area
#area dictionary with areakey and packedscene
var areas = {}
# area names that will be loaded dynamically


@export var lmao:JSON = JSON.new()
@export var map:String
var area_map:Array


func _ready():
	if(lmao.data == []):lmao.data = ['area01']
	area_map = lmao.data
	last_area = area_1
	level.connect("ready", spawn_platform)
	preload_areas()


func preload_areas():
	var areas_list:Array[StringName] = []


	for area in area_map:
		if(areas_list.has(area)):continue
		areas_list.push_back(area)
		areas[area] = load("res://level/areas/" + area + ".tscn")

func spawn_platform():

	if(area_map.size()<1):return
	var area_key = area_map[area_indx]
	var area_inst:_Area = areas[area_key].instantiate()

	area_inst.position = Vector2(last_area.end_position,0)
	level.add_child(area_inst)
	area_indx = 0 if area_indx >= area_map.size()-1 else area_indx+1
	last_area = area_inst

	area_inst.connect("enter_viewport",spawn_platform, CONNECT_ONE_SHOT)
