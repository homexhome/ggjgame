extends Node3D

@onready var area : Area3D = $Area3D

@export var website_to : String
@export var access_point_id_to : int = 0

var active : bool = false

func _ready() -> void:
	area.body_entered.connect(_on_body_enter)
	area.body_exited.connect(_on_body_exit)
	
func _on_body_enter(body : Node3D):
	if body is not Player: return
	change_active_status(true)

func _on_body_exit(body : Node3D):
	if body is not Player: return
	change_active_status(false)

func change_active_status(_status : bool):
	active = _status


func _on_area_3d_input_event(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if active == false: 
		if Input.is_action_just_pressed("left_click"):
			Session.get_browser().play_message("Access Node too far away!")
		return
	if Input.is_action_just_pressed("left_click"):
		if Session.get_tool_type() != Tool.TYPE.MOUSE:
			Session.get_browser().play_message("Can't use that")
			return
		active = false
		Loader.load_level(website_to,access_point_id_to)
