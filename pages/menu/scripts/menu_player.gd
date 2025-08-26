extends Entity

@export var cam:Camera2D
@export var movement:Movement


func stabilize_y():
	movement.velocity.y = 0
	movement.acceleration.y = 0

func _on_platform_sensor_body_entered(_body):
	PlayerStats.jumps_remaining = PlayerStats.max_jumps
	grounded = true
	emit_signal("_on_ground")

func _on_platform_sensor_body_exited(_body):
	grounded = false
	emit_signal("_off_ground")

