extends CanvasLayer
class_name LevelWindow

var Level : LevelNode

signal closed()

func _ready() -> void:
	%Title.text = " %s"%Level.LevelName
	(%Gradient.texture as GradientTexture2D).gradient.colors = [Level.WindowGradient1, Level.WindowGradient2]
	%StripeTex.visible = !Level.Beaten
	if !Level.Beaten:
		%Info.text = "Incomplete"
		return
	var InfoText : String = "Complete\nBest Time: %s\n" % LevelNode.msecs_to_str(Level.BestTime)
	if Level.BestTime < Level.GoldTime:
		InfoText += "Gold Time: %s\n" % LevelNode.msecs_to_str(Level.GoldTime)
	elif Level.BestTime < Level.DeveloperTime:
		InfoText += "Dev Time: %s\n" % LevelNode.msecs_to_str(Level.DeveloperTime)
	%Info.text = InfoText

func open():
	pass

func close():
	closed.emit()
	queue_free()

static func create_from_level(level : LevelNode):
	var inst : LevelWindow = load("res://UI/Window.tscn").instantiate()
	inst.Level = level
	level.add_child(inst)
	return inst
