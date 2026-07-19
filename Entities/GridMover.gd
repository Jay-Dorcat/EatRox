extends RayCast2D
class_name GridMover

enum {NONE,LEFT,RIGHT,UP,DOWN}

const GRID_SIZE : int = 8
const DIR2VEC : Dictionary[int,Vector2] = {
	NONE: Vector2.ZERO,
	LEFT: Vector2.LEFT,
	RIGHT: Vector2.RIGHT,
	UP: Vector2.UP,
	DOWN: Vector2.DOWN,
}
const DIR2STR : Dictionary[int,String] = {
	NONE: "None",
	LEFT: "Left",
	RIGHT: "Right",
	UP: "Up",
	DOWN: "Down",
}

@export_range(0,1024,0.1,"suffix:px/s") var MovementSpeed : float = 32

var LastDirection : int = NONE
var NextPosition : Vector2 = Vector2()

func _ready() -> void:
	NextPosition = position.snappedf(GRID_SIZE)
	process_mode = PROCESS_MODE_DISABLED
	await get_tree().process_frame
	process_mode = PROCESS_MODE_INHERIT

func _physics_process(delta: float) -> void:
	var AvailableMovement : float = MovementSpeed * delta
	while AvailableMovement > 0.001:
		if position.distance_squared_to(NextPosition) < 0.001:
			make_move()
		if LastDirection == NONE:
			break
		AvailableMovement = move_toward_next(AvailableMovement)

func move_toward_next(travel : float) -> float:
	var OldPos := position
	position = position.move_toward(NextPosition, travel)
	return travel - position.distance_to(OldPos)

func make_move():
	LastDirection = get_valid_direction()
	NextPosition = NextPosition + DIR2VEC[LastDirection] * GRID_SIZE

func get_direction_priority() -> PackedByteArray:
	return [NONE]

func get_valid_direction() -> int:
	for i in get_direction_priority():
		target_position = DIR2VEC[i] * GRID_SIZE
		force_raycast_update()
		if !is_colliding():
			return i
	return NONE

func invert_direction(dir : int):
	match dir:
		UP: return DOWN
		DOWN: return UP
		RIGHT: return LEFT
		LEFT: return RIGHT
	return NONE

func tangent_direction(dir : int):
	match dir:
		UP: return LEFT
		LEFT: return DOWN
		DOWN: return RIGHT
		RIGHT: return UP
	return NONE

func teleport_finished():
	NextPosition = position.snappedf(GRID_SIZE)
