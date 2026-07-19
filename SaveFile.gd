extends Node
class_name StateManager

const STORE_VARS : PackedStringArray = [
	"LevelTimes","CurrentLevel"
]

var DefaultVars : Dictionary[StringName,Variant]

var File : String = "user://00.save"

var LevelTimes : Dictionary[StringName,int]
var CurrentLevel : String = "res://Maps/TestMap.tscn"

func _init() -> void:
	for v in STORE_VARS:
		DefaultVars[v] = get(v)

func store_file():
	var DictData : Dictionary
	for v in STORE_VARS:
		DictData[v] = get(v)
	var ByteData : PackedByteArray = var_to_bytes(DictData).compress()
	FileAccess.open(File, FileAccess.WRITE).store_buffer(ByteData)

func load_file():
	if !FileAccess.file_exists(File):
		push_warning(File," doesn't exist.")
		return false
	var Loaded = bytes_to_var(FileAccess.get_file_as_bytes(File).decompress_dynamic(100000))
	if Loaded is not Dictionary:
		push_warning(File," is invalid.")
		return false
	for v in STORE_VARS:
		set(v, Loaded.get(v, DefaultVars.get(v)))
	return true
