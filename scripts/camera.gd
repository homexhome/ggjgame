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
