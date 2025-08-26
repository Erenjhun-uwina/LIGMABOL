extends Entity


@export var movement:Movement


func _ready():

	_on_ground.connect(func():
		movement.velocity.x = 0
		await create_tween().tween_interval(randi() % 2).finished
		jump()
	)


func jump():
	movement.velocity = Vector2(-400,-700)
