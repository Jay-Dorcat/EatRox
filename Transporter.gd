extends GPUParticles2D
class_name Transporter

const EASE : float = -2.0

var TransportObj : GridMover
var From : Vector2
var To : Vector2
var Progress : float
var MaxX : bool = false

signal transport_finished()

func transport(obj : GridMover, to : Vector2):
	TransportObj = obj
	TransportObj.visible = false
	TransportObj.process_mode = PROCESS_MODE_DISABLED
	From = obj.global_position
	global_position = From
	visible = true
	To = to
	MaxX = abs(From.x - To.x) > abs(From.y - To.y)

func _process(delta: float) -> void:
	if TransportObj:
		Progress += delta
		global_position = Vector2(
			lerpf(From.x, To.x, ease(ease(Progress, EASE if !MaxX else 1.0),EASE)),
			lerpf(From.y, To.y, ease(ease(Progress, 1.0 if !MaxX else EASE),EASE))
		)
		TransportObj.global_position = global_position
		if Progress >= 1.0:
			TransportObj.visible = true
			TransportObj.process_mode = PROCESS_MODE_INHERIT
			TransportObj.global_position = To
			TransportObj.NextPosition = To
			TransportObj = null
			transport_finished.emit()
			emitting = false
			await get_tree().create_timer(1.0).timeout
			queue_free()

static func create_transporter(obj : GridMover, to : Vector2) -> Transporter:
	var Trpt : Transporter = load("res://Objects/Transporter.tscn").instantiate()
	obj.add_sibling(Trpt)
	Trpt.transport_finished.connect(obj.teleport_finished)
	Trpt.transport(obj, to)
	return Trpt
