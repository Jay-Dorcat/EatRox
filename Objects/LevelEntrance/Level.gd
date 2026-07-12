@tool

extends Node2D

enum FileType {
	TEXT,IMAGE,FOLDER,MOVIE,VIDEO,MUSIC,
	SHEET,OBJECT,DATABASE,COLLECTION,
	WEBSITE,CAMERA,ZIPPED,TRASH,CONNECT
}

@export var LevelName : StringName = &"Unnamed"
@export var Type : FileType = FileType.TEXT:
	set(new): Type = new; update_visuals()

func _ready() -> void:
	update_visuals()

func update_visuals():
	if !is_node_ready(): return
	$Type.frame_coords.x = Type
