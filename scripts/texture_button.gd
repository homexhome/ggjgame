extends TextureButton

func _ready() -> void:
	pressed.connect(_on_press)

func _on_press():
	get_parent().hide()
