
extends Control


var distance

func _ready():
	visible = false
	%new_best_text.visible = false
	PlayerStats.connect("_on_set_dist",func(dist):distance = dist)
	PlayerStats.connect("game_over",func():visible=true)

func _on_visibility_changed():
	if(not is_node_ready()):return
	%distance.text = str(distance)
	disable_other_uis()
	animate()
	check_distance()


func check_distance():
	var v:Data = Data.read()

	if(distance > v.best_distance):
		%new_best_text.visible = true
		v.best_distance = distance
		v.save()



func disable_other_uis():
	get_tree().set_group("UIs_hidden_on_game_over","process_mode",PROCESS_MODE_DISABLED)
	get_tree().set_group("UIs_hidden_on_game_over","visible",false)


func animate():
	var main_con := get_node("main_con")
	var mc_y_pos = main_con.position.y
	main_con.position.y = mc_y_pos * -10

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(main_con,"position:y",mc_y_pos,1)

func _on_play_again_btn_button_up():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_home_btn_button_up():
	get_tree().paused = false
	get_tree().change_scene_to_packed(SceneRefs.menu)
