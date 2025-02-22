extends Area3D

@onready var camera_place = $CameraPlace

func _ready():
	body_entered.connect(place_camera_to_place)
	camera_place.hide()
	
func place_camera_to_place(body):
	if !Session.camera_initialized: return
	
	if body is Player:
		if Session.get_camera().global_position == camera_place.global_position: return
		Session.get_camera().global_position = camera_place.global_position
		Session.get_camera().skipping_frame = true
