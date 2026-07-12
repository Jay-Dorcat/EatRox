@tool
extends Area2D
class_name Portal2D

const COLOURS : PackedColorArray = [Color.HOT_PINK, Color.LIGHT_CYAN, Color.LIGHT_GREEN, Color.CORAL]

@export var TransportTime : float = 1.0
@export_enum("Pink","Cyan","Lime","Fire") var Colour : int = 0:
	set(new): Colour = new; update_visuals()
@export_enum("Square","Circle") var Shape : int = 0:
	set(new): Shape = new; update_visuals()
@export var CanReceive : bool = true
@export var CanSend : bool = true

var ConnectTo : Portal2D
var Exceptions : Array[GridMover]

func update_visuals():
	modulate = COLOURS[Colour]
	$Sprite.play([&"Square",&"Circle"][Shape])

func _ready() -> void:
	update_visuals()
	
	if Engine.is_editor_hint(): return
	
	var GroupName : StringName = &"Portal%s%s" % [Colour,Shape]
	if CanReceive:
		add_to_group(GroupName)
	await get_tree().process_frame
	if CanSend:
		var ClosestDistance : float = INF
		for i:Portal2D in get_tree().get_nodes_in_group(GroupName):
			if i != self:
				var Dist : float = i.global_position.distance_squared_to(global_position)
				if Dist < ClosestDistance:
					ClosestDistance = Dist
					ConnectTo = i
		if !ConnectTo:
			push_warning(get_path(), " No Identical Portals Available, Freeing.")
			queue_free()
		area_entered.connect(on_area_entered)
	
	await get_tree().process_frame
	remove_from_group(GroupName)

func on_area_entered(area : Area2D):
	if area.owner is GridMover:
		if area.owner in Exceptions:
			Exceptions.erase(area.owner)
			return
		Transporter.create_transporter(area.owner, ConnectTo.global_position, TransportTime).modulate = COLOURS[Colour]
		if ConnectTo.CanSend:
			ConnectTo.Exceptions.append(area.owner)
