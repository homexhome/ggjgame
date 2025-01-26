extends Area3D

@export var message : String 

func _ready() -> void:
	body_entered.connect(_on_body_enter)
	body_exited.connect(_on_body_exit)
	tree_exiting.connect(Session.set_custom_info_area.bind(null))

func _on_body_enter(body ):
	if body is Player:
		Session.set_custom_info_area(self)

func _on_body_exit(body):
	if body is Player:
		Session.set_custom_info_area(null)
