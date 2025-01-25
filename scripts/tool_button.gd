extends Button
@export var tool : Tool

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	
func _on_button_pressed():
	Session.set_tool(tool)
