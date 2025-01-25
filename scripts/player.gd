extends CharacterBody3D
class_name Player 

@export var FORWARD_SPEED = 1.0
@export var BACK_SPEED = 2.0
@export var TURN_SPEED = 0.035

@export var stop_speed : float = 10
@export var acceleration_speed : float = 10

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var browser : Browser

func _ready():
	Session.set_up_player(self)
	while Session.get_browser() == null:
		await get_tree().process_frame
	browser = Session.get_browser()

func _process(delta):
	if browser == null: return

	if browser.get_browser_line_status(): return

	move_character(delta)

func move_character(delta):
	var input_direction : Vector2 = Input.get_vector("left", "right", "forward", "back")
	var direction : Vector3 = (transform.basis.z * input_direction.y + transform.basis.x * input_direction.x).normalized()
	if input_direction == Vector2(0,0):
		velocity.z = move_toward(velocity.z,0,delta * stop_speed)
		velocity.x = move_toward(velocity.x,0,delta * stop_speed)
		
	if input_direction.y !=  0 and input_direction.x == 0:
		var _delta_y = velocity.y
		var delta_velocity = direction * (BACK_SPEED if input_direction.y > 0 else FORWARD_SPEED)
		velocity.x = move_toward(velocity.x,delta_velocity.x,delta * acceleration_speed)
		velocity.z = move_toward(velocity.z,delta_velocity.z,delta * acceleration_speed)
		velocity.y = _delta_y
	if input_direction.x !=  0:
		velocity.z = 0
		velocity.x = 0
		
		var turn_angle = -input_direction.x * TURN_SPEED 
		rotate_y(turn_angle)
	if !is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y -= gravity * 10 * delta
		
	move_and_slide()
