extends Node

var camera : Camera
var player : Player

var world : World
var browser : Browser

var camera_initialized: bool = false
var world_initialized : bool = false

var refresh_frame : bool = false

var datamosh_mount: float = 0.0
var force_datamosh:float = 0.0

func set_up_player(node):
	player = node

func get_player() -> Player:
	return player

func set_up_camera(_camera : Camera):
	camera = _camera
	camera_initialized = true

func set_up_world(_world : World):
	world = _world

func get_world() -> World:
	return world

func get_camera() -> Camera:
	return camera

func set_up_browser(_browser):
	browser = _browser

func get_browser() -> Browser:
	return browser


func array_to_vector3(array: Array) -> Vector3:
	return Vector3(array[0], array[1], array[2])

func tri_to_bi(tri:Vector3) -> Vector2:
	return Vector2(tri.x, tri.z)

func bi_to_tri(bi:Vector2, z_value:float=0.0) -> Vector3:
	return Vector3(bi.x, z_value, bi.y)

func pi_2_pi(theta):
	while theta > PI:
		theta -= 2.0 * PI

	while theta < -PI:
		theta += 2.0 * PI

	return theta

func get_datamosh_amount() -> float:
	return max(datamosh_mount, force_datamosh)
