extends GridMover
class_name PlayerNode

static var Instance : PlayerNode

@export var BaseSpeed : float = 32
@export var MaxSpeed : float = 48
@export var Acceleration : float = 6
@export var HaltBufferTime : float = 0.15

var HaltBuffer : float = 0.0
var InputOrder : PackedByteArray

func _ready() -> void:
	Instance = self
	MovementSpeed = BaseSpeed
	super()

func _notification(what: int) -> void:
	if what == NOTIFICATION_UNPAUSED:
		refresh_inputs()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"Left"):
		InputOrder.append(LEFT)
	if Input.is_action_just_pressed(&"Right"):
		InputOrder.append(RIGHT)
	if Input.is_action_just_pressed(&"Up"):
		InputOrder.append(UP)
	if Input.is_action_just_pressed(&"Down"):
		InputOrder.append(DOWN)
	
	if Input.is_action_just_released(&"Left"):
		InputOrder.erase(LEFT)
	if Input.is_action_just_released(&"Right"):
		InputOrder.erase(RIGHT)
	if Input.is_action_just_released(&"Up"):
		InputOrder.erase(UP)
	if Input.is_action_just_released(&"Down"):
		InputOrder.erase(DOWN)
	
	if LastDirection:
		$Sprite.rotation = DIR2VEC[LastDirection].angle()
		MovementSpeed = move_toward(MovementSpeed, MaxSpeed, Acceleration * delta)
		HaltBuffer = 0.0
	else:
		HaltBuffer += delta
		if HaltBuffer > HaltBufferTime:
			MovementSpeed = BaseSpeed
	
	if !InputOrder.is_empty() && InputOrder[-1] == invert_direction(LastDirection):
		MovementSpeed = BaseSpeed
		make_move()

func kill():
	await get_tree().process_frame
	get_tree().reload_current_scene()

func get_direction_priority() -> PackedByteArray:
	if InputOrder.is_empty(): return [NONE]
	var Dirs = InputOrder.duplicate()
	Dirs.reverse()
	return Dirs

func refresh_inputs():
	InputOrder.clear()
	if Input.is_action_pressed(&"Left"):
		InputOrder.append(LEFT)
	if Input.is_action_pressed(&"Right"):
		InputOrder.append(RIGHT)
	if Input.is_action_pressed(&"Up"):
		InputOrder.append(UP)
	if Input.is_action_pressed(&"Down"):
		InputOrder.append(DOWN)
