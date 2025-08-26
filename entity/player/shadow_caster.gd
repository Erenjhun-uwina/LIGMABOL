extends RayCast2D

@export var active:bool

func _ready() -> void:
	set_physics_process(active)
	update_shadow()

func update_shadow():
	var y_col:float = get_collision_point().y
	var y_global = global_position.y

	if(is_colliding()):
		$shadow.global_position.y = y_col

	var dist:float = (y_col - y_global)/30

	var energy = 1/(max(1,dist))

	$shadow.energy = min(energy,0.9)

func _physics_process(_delta: float) -> void:
	update_shadow()
