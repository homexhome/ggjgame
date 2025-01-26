extends Node3D
class_name Level

@export var website_path : String
@export var access_poits : Array[AccessPoint]

@export var need_camera : bool = true
@export var need_player : bool = true
@export var change_environment_on_load : bool = false

@export var color_first : Color
@export var color_two : Color
@export var color_three : Color

@export var event_on_load : int = -1

func _ready() -> void:
	Loader.loading_ended.connect(set_browser_line_text)
	Session.set_up_level(self)
	

func set_browser_line_text():
	Session.get_browser().set_line_text(website_path)

func get_access_point_position(id : int) -> Vector3:
	for point in access_poits:
		if point.id == id:
			return point.global_position
	return Vector3.ZERO
