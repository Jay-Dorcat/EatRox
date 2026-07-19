extends Node

var Transitioning : bool = false

signal finished()

func transition_to(sceneFile : String):
	if Transitioning:
		push_warning("Already Transitioning")
		return
	process_mode = PROCESS_MODE_ALWAYS
	Transitioning = true
	var tex := ImageTexture.create_from_image(get_viewport().get_texture().get_image())
	$Screen.texture = tex
	$Animation.play(&"Closing")
	get_tree().change_scene_to_file(sceneFile)
	get_tree().paused = true

func transition_ended():
	process_mode = PROCESS_MODE_DISABLED
	$Screen.texture = null
	get_tree().paused = false
	Transitioning = false
	finished.emit()
