extends CharacterBody3D
class_name Follower

@export var speed : float = 3
@export var nav_agent : NavigationAgent3D
@export var light : OmniLight3D
@export var animator : AnimationPlayer
var current_target
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var active : bool = true
var initialized : bool = false

var update_pos : int = 0
var max_update_pos : int = 20

@export var turn_off : bool = false

func _ready() -> void:
	Session.set_current_follower(self)
	await get_tree().create_timer(1.0).timeout
	
	if turn_off:
		change_active_status(false)
		
	if Session.get_player() == null: return
	nav_agent.target_position = Session.get_player().global_position
	initialized = true
	
func _physics_process(delta: float) -> void:
	if !initialized: return
	if !active: return
	update_pos += 1
	if Session.get_player() == null: return
	#
	if update_pos >= max_update_pos:
		update_pos = 0
		nav_agent.target_position = Session.get_player().global_position
		return
	
	var target = nav_agent.get_next_path_position() 
	var vel = (target - global_position).normalized() * speed
	#print(vel)
	nav_agent.velocity = vel
	velocity = Vector3(vel.x, velocity.y, vel.z)
	#- Vector3.UP * 0.3
	var dir = (target - global_position).normalized()
	#global_position = global_position + dir * delta * speed
	
	if global_position.distance_to(target) < 1:
		nav_agent.target_position = Session.get_player().global_position
	else:
		look_at(Vector3(target.x,global_position.y, target.z) - basis.z)
		
	velocity.y = -gravity
	move_and_slide()
	
func change_active_status(status):
	active = status
	if active:
		light.light_energy = 1
		animator.play("walk")
	else:
		light.light_energy = 0
		animator.stop()
