@tool
extends Area2D
class_name LevelNode

enum FileType {
	TEXT,IMAGE,FOLDER,MOVIE,VIDEO,MUSIC,
	SHEET,OBJECT,DATABASE,COLLECTION,
	WEBSITE,CAMERA,ZIPPED,TRASH,CONNECT,DRIVE
}

@export var LevelName : StringName = &"Unnamed"
@export var Type : FileType = FileType.TEXT:
	set(new): Type = new; update_visuals()
@export_color_no_alpha var WindowGradient1 : Color = Color("0034ff")
@export_color_no_alpha var WindowGradient2 : Color = Color("9de1ff")
@export_file("*.tscn","*.scn") var Scene : String = "res://Maps/"

func _ready() -> void:
	update_visuals()
	area_entered.connect(triggered_by)

func update_visuals():
	if !is_node_ready(): return
	$Type.frame_coords.x = Type

func triggered_by(area : Area2D):
	get_tree().paused = true
	LevelWindow.create_from_level(self).closed.connect(window_closed)

func window_closed():
	get_tree().paused = false
