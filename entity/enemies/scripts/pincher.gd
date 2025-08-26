extends Entity

class_name Pincher


var fader:Screen_fader
var dmg =25


func _ready():
	fader = get_node("/root/v_con/%Screen_fader")

	on_disable.connect(func ():
		bite_anim()

	)


func bite():
	PlayerStats.can_jump = false
	PlayerStats.essence -= dmg

func bite_anim():
	$AnimatedSprite2D.play("bite")
	create_tween().tween_property($Glow,"modulate:a",0.0,0.1)
	await $AnimatedSprite2D.animation_finished

func blind():
	if(not fader):return
	fader.cancel_all()
	fader.fade_in(0.3)
	fader.connect("fade_in_finish",func():fader.fade_out(1.7))

func _on_bite_hitbox_area_entered(_area: Area2D) -> void:
	if(disabled):return
	disabled = true
	bite()
	blind()

func _on_bite_hitbox_area_exited(_area: Area2D) -> void:
	PlayerStats.can_jump = true
