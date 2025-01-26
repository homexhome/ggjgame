extends TextureButton
@export var tool : Tool
@export var set_default : bool = false
@export var need_release_focus : bool = false
func _ready() -> void:
	pressed.connect(_on_button_pressed)
	if set_default:
		_on_button_pressed()
	
func _on_button_pressed():
	Session.set_tool(tool)
	if need_release_focus:
		await get_tree().create_timer(1.0).timeout
		release_focus()
