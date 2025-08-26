extends PanelContainer

class_name Upgrade_display

@export var container:Control
@export var temp_card:PanelContainer
var cards:Array[Node]


func _ready():
	for i in range(PlayerStats.max_abilities-1):
		container.add_child(temp_card.duplicate())
	cards = container.get_children()
	update_cards()

func update_cards():
	var path = "res://GUI/src/imgs/"
	for i in  range(PlayerStats.abilities_count):
		if(i >= PlayerStats.max_abilities):break
		
		var card = cards[i]
		var ability:Ability = PlayerStats.abilities[i]
		
		var texture:CompressedTexture2D = load(path+ability.get_texture())
		var texture_rect:TextureRect = card.get_node("texture")
		texture_rect.texture = texture
