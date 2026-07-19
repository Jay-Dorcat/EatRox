extends Node2D
var shooting: bool = false
var wall: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shooting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shooting:
		$LaserBeam.add_point(Vector2(0,0))
		if $RayCast2D.is_colliding():
			wall = $RayCast2D.get_collision_point()
			$LaserBeam.add_point(wall)
			
		
	# Oh my god, BRAIN PLEASEEE
