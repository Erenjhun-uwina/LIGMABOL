extends _Area

var player:Player

func _ready():
	pass


func _on_Area2D_body_entered(player:Player):

	self.player = player
	player.state_m.set_state("falling")
	player.stop_movement()

	var tween = create_tween()
	tween.tween_interval(2)
	tween.tween_callback(Callable(self, "test"))

func test():
	player.state_m.set_enable()
	player.state_m.set_state("jumping")
	PlayerStats.essence += PlayerStats.jump_cost

	await create_tween().tween_interval(2).finished
	PlayerStats.idle = false
	print("goooooooooo")
