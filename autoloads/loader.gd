extends Node

var access_points : Array

var all_levels : Dictionary
@onready var player_scene = preload("res://scenes/player.tscn")
@onready var camera_scene = preload("res://scenes/camera.tscn")
@onready var browser_scene = preload("res://scenes/browser.tscn")

@export var event_on_load : int = -1

var loading : bool = false

var loaded_scenes : Array

signal loading_started
signal loading_ended

func _ready() -> void:
	load_all_levels()
	var browser = browser_scene.instantiate()
	while Session.get_world() == null:
		await get_tree().process_frame
	Session.get_world().add_child(browser)

func load_level(path : String, place_id_for_player : int = 0, last_level : String = ""):
	while Session.get_world() == null:
		await get_tree().process_frame
	if loading: return false
	var loaded : bool = false

	loading = true
	loading_started.emit()
	if all_levels.has(path):
		free_all_loaded_scenes()

		var level = all_levels[path].duplicate()
		Session.get_world().add_child(level)
		await get_tree().process_frame

		var camera = null
		if level.need_camera:
			camera = camera_scene.instantiate()
			level.add_child(camera)
			await get_tree().process_frame

		var player = null
		if level.need_player:
			player = player_scene.instantiate()
			level.add_child(player)
			player.global_position = level.get_access_point_position(place_id_for_player)

		if level.event_on_load != -1:
			Session.add_event(level.event_on_load)

		if level.loading_another_level_node != null and last_level != "":
			level.loading_another_level_node.pass_last_level(last_level)

		loaded_scenes.append_array([level,camera,player])
		loaded = true
		Session.get_browser().set_line_text(level.website_path)
	loading = false
	if loaded:
		await get_tree().create_timer(1.0).timeout
		Session.clear_ads()
	loading_ended.emit()
	return loaded

func free_all_loaded_scenes():
	for scene in loaded_scenes:
		if is_instance_valid(scene) and scene != null:
			scene.queue_free()
	loaded_scenes.clear()

func load_all_levels():
	var _all_levels = DirAccess.get_files_at("res://scenes/levels/")
	for path in _all_levels:
		path = "res://scenes/levels/" + path
		var level = load(path).instantiate()
		all_levels[level.website_path] = level
