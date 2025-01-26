extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_enter)

func _on_body_enter(body):
	if body is not Player: return
	
