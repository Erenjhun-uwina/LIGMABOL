extends Control

@export var player:CharacterBody2D

func _ready():
	animate_label()
	%best_label.text  = "best:%s" % Data.read().best_distance
	player.get_node("%trick").connect("trick",remove_anim)

func remove_anim():
	var tween:= create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self,"position:y",-500,0.2)

func animate_label():
	var label = get_node("%press_start_label")
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(label,"modulate",Color(0.3,0.3,0.3),0.5)
	tween.tween_property(label,"modulate",Color.WHITE,0.2).set_ease(Tween.EASE_OUT)
	tween.tween_interval(0.5)
