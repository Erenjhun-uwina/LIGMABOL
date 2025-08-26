extends Entity


@onready var movement:Movement = %Movement
@export_file var glow_image
@onready var glow:Sprite2D = Sprite2D.new()
const damage = 30

func _ready() -> void:
	glow.texture = load(glow_image)
	movement.velocity.x = -200

func explode():
	PlayerStats.essence -= damage
	animate_glow()
	queue_free()

func animate_glow():
	if(disabled):return
	disabled = true

	get_parent().add_child(glow)
	glow.global_position = global_position
	var tween = glow.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(glow,"scale",Vector2.ONE*3,0.3)
	tween.chain().tween_property(glow,"modulate:a",0,0.6)


func _on_player_detector_area_entered(_area: Area2D) -> void:
	explode()
