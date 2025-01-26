extends Node3D
class_name Level

@export var website_path : String
@export var access_poits : Array[AccessPoint]

func _ready() -> void:
	Loader.loading_ended.connect(set_browser_line_text)

func set_browser_line_text():
	Session.get_browser().set_line_text(website_path)

func get_access_point_position(id : int) -> Vector3:
	for point in access_poits:
		if point.id == id:
			return point.global_position
	return Vector3.ZERO
