extends Camera3D
class_name Camera

var player : Player
var last_player_pos : Vector3
var skipping_frame : bool = false

func _ready():
	Session.set_up_camera(self)
	ready.connect(set_up_player)
	
func set_up_player():
	player = Session.get_player()
	if player != null:
		look_at(player.global_position)
		skipping_frame = true

func _process(_delta):
	if player != null:
		if skipping_frame:
			look_at(player.global_position)
			skipping_frame = false
		else:
			var old = transform.basis
			look_at(player.global_position)
			var new = transform.basis
			transform.basis = lerp(old, new, .1).orthonormalized()
	else:
		set_up_player()


func _physics_process(delta: float) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var origin = project_ray_origin(mouse_position)
	var direction = project_ray_normal(mouse_position)
	var ray_length = far
	var end = origin + direction * ray_length
	var query = PhysicsRayQueryParameters3D.create(origin, end, 1)
	query.collide_with_areas = true
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)
	if result != {}:
		if result.has("collider") and result["collider"].is_in_group("Interactable"):
			Session.set_current_interact(result["collider"])
			Session.get_current_interact().interact()
