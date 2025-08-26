extends Entity

const dmg = 25
var bounced = false

func disable():
	pass

func splat():
	$AnimatedSprite2D.play("splat")
	call_deferred("animate_collision_shapes")

func animate_collision_shapes():
	$player_detector/CollisionShape2D2.disabled = false
	$player_detector/CollisionShape2D.disabled = true

func _on_player_detector_area_entered(area: Area2D) -> void:
	var player:Player = area.get_parent()
	PlayerStats.can_jump = false

	var p_state = player.state_m.curr_state.name
	if(bounced):return
	if(p_state == "diving" or p_state == "falling"):
		player.position.y = player.global_position.y-64
		player.bounce()
		bounced = true
		splat()
		return
	player.movement.velocity.x = max(0,player.movement.velocity.x-100)
	PlayerStats.essence -= dmg

func _on_player_detector_area_exited(_area: Area2D) -> void:
	PlayerStats.reset_jump()
