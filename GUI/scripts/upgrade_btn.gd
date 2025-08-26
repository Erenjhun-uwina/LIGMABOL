extends Button

class_name Upgrade_button

@export var title_label:Label
@export var desc_label:Label
@export var upg_icon:TextureRect

@export var title_text:String = "title" :set = set_title_text
@export var desc_text:String = "sample sample sample description wow" :set = set_desc_text
var code = ""

func _ready():
	self.title_text = title_text
	self.desc_text = desc_text

func set_title_text(val):
	title_text = val
	title_label.text = val

func set_desc_text(val):
	desc_text = val
	desc_label.text = val

func set_icon(path):
	upg_icon.texture = load(path)
