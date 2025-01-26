extends CharacterBody3D
class_name Follower

@export var speed : float = 3
@export var nav_agent : NavigationAgent3D
@export var light : OmniLight3D
var current_target
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var active : bool = true
var initialized : bool = false

var update_pos : int = 0
var max_update_pos : int = 20

func _ready() -> void:
	Session.set_current_follower(self)
	await get_tree().create_timer(1.0).timeout
	initialized = true

func _physics_process(delta: float) -> void:
	if !initialized: return
	if !active: return
	update_pos += 1
	if Session.get_player() == null: false
	
	if update_pos >= max_update_pos:
		update_pos = 0
		nav_agent.target_position = Session.get_player().global_position
	
	var target = nav_agent.get_next_path_position() - Vector3.UP * 0.3
	var dir = (target - global_position).normalized()
	global_position = global_position + dir * delta * speed
	if global_position.distance_squared_to(target) > 1:
		look_at(global_position + dir)
	else:
		nav_agent.target_position = Session.get_player().global_position

func change_active_status(status):
	active = status
	if active:
		light.light_energy = 1
	else:
		light.light_energy = 0
