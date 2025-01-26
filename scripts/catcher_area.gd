extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_enter)

func _on_body_enter(body):
	if body is not Player: return
	var current_level = Session.get_current_level().website_path
	Loader.load_level("http://world/redroom",0,current_level)
