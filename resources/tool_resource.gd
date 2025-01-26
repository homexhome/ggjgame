extends Resource
class_name Tool

enum TYPE {SCALING_PLUS, SCALING_MINUS, ROTATING, INFO, TALKING, MOUSE}
@export var tool_type : TYPE
@export var mouse_texture : Texture

func register_type():
	Session.set_tool(self)
