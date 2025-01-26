extends Area3D

@onready var follower_scene = preload("res://scripts/follower.tscn")
@onready var place_to_spawn = $PlaceToSpawn
func _ready() -> void:
	place_to_spawn.hide()
	body_entered.connect(_on_body_enter)
	
func _on_body_enter(body):
	if body is not Player: return
	if Session.get_current_follower() == null or is_instance_valid(Session.get_current_follower()) == false:
		var follower = follower_scene.instantiate()
		Session.get_current_level().add_child(follower)
		follower.global_position = place_to_spawn.global_position
