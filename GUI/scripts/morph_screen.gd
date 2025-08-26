extends Control


@export var btns_container:Control
@export var upgrade_display:Upgrade_display
var btns:Array[Node]
signal upgrade_chosen(title)
var active:bool = false
var game_over = false


func _ready():
	visible = false
	btns = btns_container.get_children()
	connect_signals()

func new_values():
	setup_btns()
	upgrade_display.update_cards()

func setup_btns():

	var upgrades:Array = PlayerStats.random_avail_abilities_pool()


	var path = "res://GUI/src/imgs/"

	for i in range(3):
		var btn = btns[i]
		var poped = upgrades.pop_front()
		var upgrade:Ability = poped if poped!=null else Ability.new()

		btn.title_text = upgrade.title
		btn.desc_text = upgrade.desc
		if(typeof(btn) != TYPE_DICTIONARY):
			btn.set_icon(path+upgrade.get_texture())

func connect_signals():

	PlayerStats.game_over.connect(func():game_over = true)
	PlayerStats.morph_start.connect(
		func(_dur):
			if(game_over):return
			new_values()
			toggle()
	)


	for btn in btns:
		btn.connect("pressed",
			func():
				var title = btn.title_text
				if(title == ""):return
				toggle()
				if(PlayerStats.abilities_count >= PlayerStats.max_abilities):return
				PlayerStats.append_ability(title)
	)

func toggle():
	visible = not visible
	get_tree().paused =  visible
