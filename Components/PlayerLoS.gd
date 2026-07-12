extends RayCast2D
class_name PlayerLosCheck

#@export var GridAligned : bool = false

func is_player_sighted() -> bool:
	target_position = to_local(PlayerNode.Instance.global_position)
	force_raycast_update()
	return !is_colliding()
