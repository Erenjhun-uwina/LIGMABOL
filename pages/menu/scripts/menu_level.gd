extends Node2D

@onready var player = get_node("%bol")
@onready var movement:Movement
@export var fader:Screen_fader


func _ready():
	fader.fade_out(1)
	SoundManager.play_bg()

func transition():
	get_tree().change_scene_to_packed(SceneRefs.main_level)

func _on_visible_on_screen_notifier_2d_screen_exited():
	fader.connect("fade_in_finish",transition,CONNECT_ONE_SHOT)
	fader.fade_in(0.5)
