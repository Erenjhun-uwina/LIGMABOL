extends Control

@onready var essence_bar:ProgressBar= %essence_bar
@onready var morph_bar:ProgressBar= %morph_bar
@onready var dist_meter := %Distance_meter
@onready var ability_con := %ability_vbox


func _ready():
	PlayerStats._on_set_essence.connect(set_essence)
	PlayerStats._on_set_dist.connect(set_dist)

	PlayerStats.morph_start.connect(start_morph_bar_anim)
	PlayerStats.ability_cast.connect(highlight_next_ability_icon)

	PlayerStats.max_essence_set.connect(
		func (value):
			essence_bar.max_value = int(value)
	)

	PlayerStats.ability_added.connect(
		func(ability):
			var index = PlayerStats.abilities_count-1
			var con = ability_con.get_child(index)
			var icon = ability.get_texture()
			con.get_node("icon").texture = load("res://GUI/src/imgs/"+icon)
	)
	set_essence(PlayerStats.essence)
	remove_highlight()

func highlight_next_ability_icon(index):
	remove_highlight()
	var icon = ability_con.get_children()[index].get_theme_stylebox("panel")
	icon.border_color  = Color.ORANGE_RED
	SceneRefs.last_icon_selected = icon

func remove_highlight():
	var last_icon_selected = SceneRefs.last_icon_selected
	if(last_icon_selected):last_icon_selected.border_color = Color.BLACK


func start_morph_bar_anim(duration):
	var tween:= create_tween()
	await tween.tween_property(morph_bar,"value",100,duration).finished
	morph_bar.value = 0

func set_essence(value):
	essence_bar.value = value

func set_dist(value):
	dist_meter.text = "distance : %s" % value

func update_ability_display(index:int):
	var con = ability_con.get_child(index)
	var icon = PlayerStats.abilities[index].get_texture()
	con.get_node("icon").texture = load("res://GUI/src/imgs/"+icon)
