extends Control

var paused = false


func _ready():
	visible = false
	%best_label.text = "best distance : %s" %Data.read().best_distance

func toggle_pause():
	paused = !paused
	visible = paused
	get_tree().paused = paused
	disable_other_uis(paused)

func _unhandled_key_input(_event):
	if(Input.is_key_pressed(KEY_ESCAPE)):
		toggle_pause()

func disable_other_uis(val:bool = true):
	get_tree().get_nodes_in_group("UIs_hidden_on_pause").map(
		func (ui):
			ui.visible = not val and ui.active
	)


func _on_exit_btn_pressed():
	toggle_pause()
	get_tree().change_scene_to_packed(SceneRefs.menu)


func _on_restart_btn_pressed():
	toggle_pause()
	get_tree().reload_current_scene()


func _on_resume_btn_pressed():
	toggle_pause()
