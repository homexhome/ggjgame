extends CSGBox3D
class_name ScalableObject

enum STATE {SMALL,NORMAL,LARGE}
@export var scale_state : STATE = STATE.LARGE
@onready var collision : CollisionShape3D = $Area3D/CollisionShape3D

const SMALL_SCALE : float = 0.3
const NORMAL_SCALE : float = 0.6
const LARGE_SCALE : float = 1.0


var changing_scale : bool = false
	
@export var material_good_hover : StandardMaterial3D
@export var material_bad_hover : StandardMaterial3D
@onready var area = $Area3D

func _ready() -> void:
	material_good_hover = preload("res://resources/good_hover.tres")
	material_bad_hover = preload("res://resources/bad_hover.tres")
	if area.mouse_exited.is_connected(_on_area_3d_mouse_exited) == false:
		area.mouse_exited.connect(_on_area_3d_mouse_exited)
	collision.shape = collision.shape.duplicate()

func increase_object_scale(_state : STATE):
	if scale_state == _state: return
	if changing_scale: return
	changing_scale = true
	var tween = create_tween()
	var _tween = create_tween()
	var __tween = create_tween()
	var y_pos = position.y
	
	if scale_state == STATE.LARGE:
		Session.get_browser().play_message("Can't use that")
		return

	if scale_state == STATE.NORMAL:
		if _state == STATE.LARGE:
			y_pos += 0.2
	if scale_state == STATE.SMALL:
		if _state == STATE.NORMAL:
			y_pos += 0.15
	$AudioStreamPlayer3D.play()
	match _state:
		STATE.LARGE:
			__tween.tween_property(collision.shape, "size", Vector3(collision.shape.size.x,LARGE_SCALE + 0.1,collision.shape.size.z), 1)
			_tween.tween_property(self, "position", Vector3(position.x,y_pos,position.z), 1)
			await tween.tween_property(self, "size", Vector3(size.x,LARGE_SCALE,size.z), 1).finished

		STATE.NORMAL:
			__tween.tween_property(collision.shape, "size", Vector3(collision.shape.size.x,NORMAL_SCALE + 0.1,collision.shape.size.z), 1)
			_tween.tween_property(self, "position", Vector3(position.x,y_pos,position.z), 1)
			await tween.tween_property(self, "size", Vector3(size.x,NORMAL_SCALE,size.z), 1).finished

	scale_state = _state
	changing_scale = false

func decrease_object_scale(_state : STATE):
	if scale_state == _state: return
	if changing_scale: return
	changing_scale = true
	var tween = create_tween()
	var _tween = create_tween()
	var __tween = create_tween()
	var y_pos = position.y
	
	if scale_state == STATE.SMALL:
		Session.get_browser().play_message("Can't use that")
		return

	if scale_state == STATE.NORMAL:
		if _state == STATE.SMALL:
			y_pos -= 0.15

	if scale_state == STATE.LARGE:
		if _state == STATE.NORMAL:
			y_pos -= 0.2
	$AudioStreamPlayer3D.play()
	match _state:
		STATE.NORMAL:
			__tween.tween_property(collision.shape, "size", Vector3(collision.shape.size.x,NORMAL_SCALE + 0.1,collision.shape.size.z), 1)
			_tween.tween_property(self, "position", Vector3(position.x,y_pos,position.z), 1)
			await tween.tween_property(self, "size", Vector3(size.x,NORMAL_SCALE,size.z), 1).finished

		STATE.SMALL:
			__tween.tween_property(collision.shape, "size", Vector3(collision.shape.size.x,SMALL_SCALE + 0.1,collision.shape.size.z), 1)
			_tween.tween_property(self, "position", Vector3(position.x,y_pos,position.z), 1)
			await tween.tween_property(self, "size", Vector3(size.x,SMALL_SCALE,size.z), 1).finished

	scale_state = _state
	changing_scale = false



func _on_area_3d_input_event(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	match Session.get_tool_type():
		Tool.TYPE.SCALING_PLUS:
			if scale_state == STATE.LARGE:
				material_override = material_bad_hover
			else:
				material_override = material_good_hover

		Tool.TYPE.SCALING_MINUS:
			if scale_state == STATE.SMALL:
				material_override = material_bad_hover
			else:
				material_override = material_good_hover
		

	if Input.is_action_just_pressed("left_click"):
		match Session.get_tool_type():
			Tool.TYPE.SCALING_PLUS:
				if scale_state == STATE.SMALL:
					increase_object_scale(STATE.NORMAL)
				elif scale_state == STATE.NORMAL:
					increase_object_scale(STATE.LARGE)
				else:
					Session.get_browser().play_message("Can't use that")
			Tool.TYPE.SCALING_MINUS:
				if scale_state == STATE.NORMAL:
					decrease_object_scale(STATE.SMALL)
				elif scale_state == STATE.LARGE:
					decrease_object_scale(STATE.NORMAL)
				else:
					Session.get_browser().play_message("Can't use that")
		


func _on_area_3d_mouse_exited() -> void:
	if material_override != null:
		material_override = null
