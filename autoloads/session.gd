extends Node

var camera : Camera
var player : Player

var world : World
var browser : Browser

var current_level : Level

var current_follower : Follower

var camera_initialized: bool = false
var world_initialized : bool = false

var refresh_frame : bool = false

var datamosh_mount: float = 0.0
var force_datamosh:float = 0.0

var active_tool : Tool

var custom_info_area

var all_events : Dictionary
var current_environment : WorldEnvironment

signal info_signal


func set_up_player(node):
	player = node

func get_player() -> Player:
	return player

func set_up_camera(_camera : Camera):
	camera = _camera
	camera_initialized = true

func set_up_world(_world : World):
	world = _world
	current_environment = world.get_node("WorldEnvironment")

func get_world() -> World:
	return world

func get_camera() -> Camera:
	return camera

func set_up_browser(_browser):
	browser = _browser

func get_browser() -> Browser:
	return browser

func set_up_level(level):
	current_level = level

func get_current_level() -> Level:
	return current_level

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

func set_tool(_tool : Tool):
	active_tool = _tool
	if active_tool.tool_type == Tool.TYPE.INFO:
		info_signal.emit()
		if custom_info_area != null:
			browser.play_important_message(custom_info_area.message)
		else:
			browser.play_important_message("Use your tools!", 3.0)
	if _tool.mouse_texture != null:
		Input.set_custom_mouse_cursor(_tool.mouse_texture)

func get_tool_type() -> Tool.TYPE:
	if active_tool == null:
		return Tool.TYPE.MOUSE
	return active_tool.tool_type

func set_custom_info_area(area):
	custom_info_area = area
	if custom_info_area != null:
		browser.play_important_message(custom_info_area.message)

func set_current_follower(follower):
	current_follower = follower

func get_current_follower() -> Follower:
	return current_follower

func add_event(id : int):
	if all_events.has(id) == false:
		all_events[id] = 0

func check_event(id : int):
	return all_events.has(id)
