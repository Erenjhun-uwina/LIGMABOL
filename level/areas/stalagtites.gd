extends StaticBody2D



func _ready() -> void:
	fall()


func fall()->void:
	var tween = create_tween()

	tween.set_trans(Tween.TRANS_CIRC)
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(self,"position:y",1000,2)
