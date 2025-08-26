@tool
extends StaticBody2D


class_name Platform
@export var dynamic = true
@export var tile_w: int = 1: set = set_tile_w
@export var tile_h: int = 10: set = set_tile_h
@export var end_point:int = 64

var width
var height

var map:TileMap
var collider

func _ready():
	self.tile_w = tile_w
	self.tile_h = tile_h

func set_tile_h(h:int  = 3):
	tile_h = h
	update_shape()

func set_tile_w(w:int = 3):
	tile_w = w
	update_shape()

func update_collider_shape():
	collider.shape.size.x = width
	collider.shape.size.y = height - 64
	collider.position.x = width/2
	collider.position.y = height/2 + 32
	end_point = width + position.x


func update_size_vars():
	self.width = tile_w  * 64
	self.height = tile_h * 64

func update_map():
	map.clear()

	var cell:Vector2i = Vector2i(1,0)

	for i in tile_w:
		for j in tile_h:


			if(j<3):cell.y = j
			else:cell.y = 2

			if(tile_w<2):cell.x = 5
			elif (i==0):cell.x = 1
			elif(i==tile_w-1):cell.x = 4
			else:cell.x = 2 if randf() > 0.3 else 3

			map.set_cell(0,Vector2i(i,j),0,cell)

func update_shape():

	if(not has_node("collider")):return
	if(has_node("%TileMap")):map = get_node("%TileMap")
	collider = get_node("collider")

	update_size_vars()
	update_collider_shape()

	if(not dynamic || not map):return
	update_map()
