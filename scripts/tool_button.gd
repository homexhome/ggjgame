extends TextureButton
@export var tool : Tool
@export var set_default : bool = false
@export var need_release_focus : bool = false
var initialized : bool = false
func _ready() -> void:
	pressed.connect(_on_button_pressed)
	if set_default:
		_on_button_pressed()
	initialized = true
	
func _on_button_pressed():
	Session.set_tool(tool)
	if initialized:
		$"../AudioStreamPlayer".pitch_scale = randf_range(0.7,1.2)
		$"../AudioStreamPlayer".play()
	if need_release_focus:
		await get_tree().create_timer(1.0).timeout
		release_focus()
