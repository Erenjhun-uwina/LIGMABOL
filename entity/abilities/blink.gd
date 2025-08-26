extends Ability

class_name Blink_ability

var level:Level
var movement:Movement
var trail:Trail
var eye_trail:Trail
var blast:Sprite2D
var sensor:Area2D
var max_speed:int = 600

func _init():
	super("blink",
	["blinks into the nearest
	enemy or essence obliterating
	any enemies within a radius at
	end position"],
	["blink"]
	)

	cost = 30
	spammable = false
	cd = 2

func _on_set_entity():
	level = entity.get_parent()
	movement = get_node("%Movement")
	movement = get_node("%Movement")
	trail = get_node("%Trail")
	eye_trail =  get_node("%Eye_Trail")
	blast = get_node("%Blast")
	sensor = get_node("%General_sensor")

	sensor.body_entered.connect(func(bod:Entity):
		if(bod is Pincher):
			bod.disabled = true
	)

func cast():

	var nearest:CharacterBody2D = find_nearest_en()
	finished = false

	if(is_instance_valid(nearest)):
		var nearest_pos = nearest.global_position
		await jump().finished
		finished = true
		await blink(nearest_pos).finished

func blink(position:Vector2)->IntervalTweener:
	entity.stabilize_y()
	finish.emit()
#	set_sensor_vars()
	position.y -= 90
	entity.position = position

	trail.deact(0.2)
	eye_trail.deact(0.2)

	PlayerStats.reset_jump()
	resize_sensor()


	return animate_blink()

func resize_sensor(active:= true):
	sensor.scale =  Vector2.ONE * (93 if active else 0)

func animate_blink():
	var tween = entity.create_tween()
	tween.tween_property(blast,"scale",Vector2.ONE*5,0.2).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func():
		resize_sensor(false)
	)
	tween.parallel().tween_property(blast,"modulate:a",0,0.5)

	tween.tween_callback(func():
		blast.scale = Vector2.ONE
		blast.modulate.a = 1
		)

	return tween.tween_interval(0.01)

func jump()->IntervalTweener:
	trail.active = true
	eye_trail.active = true
	entity.stabilize_y()
	movement.velocity.x = 0
	movement.velocity.y -= 900
	return entity.create_tween().tween_interval(0.2)

func find_nearest_en()->CharacterBody2D:
	var nearest:CharacterBody2D = null

	for area in level.get_areas():
		var en_entity:CharacterBody2D = find_nearest_en_in_area(area)

		if(not en_entity):continue

		if(nearest == null):
			nearest = en_entity
			continue

		if(en_entity.global_position.x < nearest.global_position.x):
			nearest = en_entity

	return nearest

func find_nearest_en_in_area(area:_Area)->CharacterBody2D:

	var entities := area.get_node("entities").get_children()

	var nearest:CharacterBody2D = null
	for en_entity in entities:

		#excludes enemies behind the player
		#and enemies that is disabled
		if(en_entity.disabled or  en_entity.global_position.x  < entity.global_position.x):
			continue

		if (nearest == null):
			nearest = en_entity
			continue

		if(en_entity.global_position.x < nearest.global_position.x):
			nearest = en_entity

	return nearest
