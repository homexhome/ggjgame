extends TextureButton

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed():
	if Session.get_current_level() != null:
		Loader.load_level(Session.get_current_level().website_path)
