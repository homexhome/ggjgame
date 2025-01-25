extends Node3D
class_name Level

@export var website_path : String
@export var access_poits : Array[AccessPoint]


func get_access_point_position(id : int) -> Vector3:
	for point in access_poits:
		if point.id == id:
			return point.global_position
	return Vector3.ZERO
