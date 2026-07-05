extends GridMover

func _process(_delta: float) -> void:
	if LastDirection:
		$Sprite.frame = [1,0,2,3][LastDirection-1]

func get_direction_priority() -> PackedByteArray:
	var LocalPlayer : Vector2 = to_local(PlayerNode.Instance.global_position)
	
	var Directions : Array = [LEFT,RIGHT,UP,DOWN]
	Directions.erase(invert_direction(LastDirection))
	Directions.sort_custom(func(a : int, b : int):
		return (DIR2VEC[a] - LocalPlayer).length_squared() < (DIR2VEC[b] - LocalPlayer).length_squared()
	)
	Directions.append(invert_direction(LastDirection))
	return Directions
