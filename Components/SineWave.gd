extends Node2D

@export var Frequency : float = 1.0
@export var Amplitude : float = 1.0

var Wave : float = 0.0

func _process(delta: float) -> void:
	Wave = fmod(Wave + delta * Frequency, 1.0)
	position.y = sin(Wave * TAU) * Amplitude
