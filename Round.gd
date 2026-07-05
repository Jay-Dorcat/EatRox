extends Node2D

func _ready() -> void:
	update()
	get_parent().child_order_changed.connect(update)
	child_order_changed.connect(recheck)

func recheck():
	if get_child_count() == 0:
		queue_free()

func update():
	if get_index() == 0:
		visible = true
		process_mode = PROCESS_MODE_INHERIT
	else:
		visible = false
		process_mode = PROCESS_MODE_DISABLED
