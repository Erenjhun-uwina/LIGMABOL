extends Ability

class_name Blast_ability

var sensor:Area2D
var scale_multiplier = 11
var blast_sprite:Sprite2D 

func _init():
	super("blast",
	["release a shock wave thats consumes essence within a radius"],
	["blast"]
	)
	spammable = false
	

func _on_set_entity():
	blast_sprite = entity.get_node("%Blast")
	sensor = entity.get_node("%essence_sensor")

func cast():
	sensor.body_entered.connect(speed_up_essence)
	sensor.scale  *= scale_multiplier
	animate_blast()

func animate_blast():
	if(not finished):return
	finished = false
	
	var tween:Tween = entity.create_tween()
	
	tween.tween_callback(func():
		sensor.scale  /= scale_multiplier
	).set_delay(0.1)
	
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(blast_sprite,"scale",Vector2.ONE*50,0.3)
	tween.parallel().tween_property(blast_sprite,"modulate:a",0,0.4)
	tween.tween_callback(reset)

func reset():
	blast_sprite.scale = Vector2.ZERO
	blast_sprite.modulate.a = 1
	finished = true
	sensor.body_entered.disconnect(speed_up_essence)
	finish.emit()

func speed_up_essence(essence:Essence):
	essence.speed*= 5

