extends Node

@export var id : int

func _ready() -> void:
	if Session.check_event(id) == false:
		get_parent().queue_free()
