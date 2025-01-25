extends Node3D
class_name AccessPoint

@export var id : int = -1
@onready var spawn_point = $SpawnPoint

func _ready():
	hide()

func spawn_player():
	Session.get_player().global_position = spawn_point.global_position
