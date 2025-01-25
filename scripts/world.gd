extends Node3D
class_name World

func _ready() -> void:
	Session.set_up_world(self)
