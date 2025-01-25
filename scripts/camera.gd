extends Camera3D
class_name Camera

var player : Player

func _ready():
	Session.set_up_camera(self)
	ready.connect(set_up_player)
	
func set_up_player():
	player = Session.get_player()
	
func _process(delta):
	if player != null:
		look_at(player.global_position)
	else:
		set_up_player()
