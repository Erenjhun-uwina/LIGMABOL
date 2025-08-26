extends Marker2D

@onready var bod = $body
@onready var glow = $eye_glow
var tween:Tween

func _ready():
	
	tween = create_tween()
	tween.set_loops()
	
	var pos = position
	var pos_off = Vector2(0,40)
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"position", pos - pos_off,0.5)
	tween.tween_property(self,"position", pos,0.4)
