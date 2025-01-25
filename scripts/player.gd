extends CharacterBody3D
class_name Player 

@export var FORWARD_SPEED = 1.0
@export var BACK_SPEED = 2.0
@export var TURN_SPEED = 0.035

@export var stop_speed : float = 10
@export var acceleration_speed : float = 10


@export_category("Debug Settings")
@export var STEP_DOWN_DEBUG := false	
@export var STEP_UP_DEBUG := false

@export var MAX_STEP_UP := 0.5			# Maximum height in meters the player can step up.
@export var MAX_STEP_DOWN := -0.5	
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var browser : Browser
@export var animation_player : AnimationPlayer

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
	wish_dir = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	var direction : Vector3 = (transform.basis.z * input_direction.y + transform.basis.x * input_direction.x).normalized()
	if input_direction == Vector2(0,0):
		velocity.z = move_toward(velocity.z,0,delta * stop_speed)
		velocity.x = move_toward(velocity.x,0,delta * stop_speed)
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
	if input_direction.y !=  0 and input_direction.x == 0:
		var _delta_y = velocity.y
		var delta_velocity = direction * (BACK_SPEED if input_direction.y > 0 else FORWARD_SPEED)
		velocity.x = move_toward(velocity.x,delta_velocity.x,delta * acceleration_speed)
		velocity.z = move_toward(velocity.z,delta_velocity.z,delta * acceleration_speed)
		velocity.y = _delta_y
		if animation_player.current_animation != "walk":
			animation_player.play("walk")
	if input_direction.x !=  0:
		velocity.z = 0
		velocity.x = 0
		
		var turn_angle = -input_direction.x * TURN_SPEED 
		rotate_y(turn_angle)
	if !is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y -= gravity * 10 * delta
	
	stair_step_up()
	move_and_slide()
	stair_step_down()

# Function: Handle walking down stairs
func stair_step_down():
	if is_grounded:
		return

	# If we're falling from a step
	if velocity.y <= 0 and was_grounded:
		_debug_stair_step_down("SSD_ENTER", null)

		# Initialize body test variables
		var body_test_result = PhysicsTestMotionResult3D.new()
		var body_test_params = PhysicsTestMotionParameters3D.new()

		body_test_params.from = self.global_transform			## We get the player's current global_transform
		body_test_params.motion = Vector3(0, MAX_STEP_DOWN, 0)	## We project the player downward

		if PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result):
			# Enters if a collision is detected by body_test_motion
			# Get distance to step and move player downward by that much
			position.y += body_test_result.get_travel().y
			apply_floor_snap()
			is_grounded = true
			_debug_stair_step_down("SSD_APPLIED", body_test_result.get_travel().y)					## DEBUG

var is_grounded := true					# If player is grounded this frame
var was_grounded := true				# If player was grounded last frame

var wish_dir := Vector3.ZERO			# Player input (WASD) direction

var vertical := Vector3(0, 1, 0)		# Shortcut for converting vectors to vertical
var horizontal := Vector3(1, 0, 1)		# Shortcut for converting vectors to horizontal


func stair_step_up():
	if wish_dir == Vector3.ZERO:
		return

	_debug_stair_step_up("SSU_ENTER", null)															## DEBUG

	# 0. Initialize testing variables
	var body_test_params = PhysicsTestMotionParameters3D.new()
	var body_test_result = PhysicsTestMotionResult3D.new()

	var test_transform = global_transform				## Storing current global_transform for testing
	var distance = wish_dir * 0.1						## Distance forward we want to check
	body_test_params.from = self.global_transform		## Self as origin point
	body_test_params.motion = distance					## Go forward by current distance

	_debug_stair_step_up("SSU_TEST_POS", test_transform)											## DEBUG

	# Pre-check: Are we colliding?
	if !PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result):
		_debug_stair_step_up("SSU_EXIT_1", null)													## DEBUG

		## If we don't collide, return
		return

	# 1. Move test_transform to collision location
	var remainder = body_test_result.get_remainder()							## Get remainder from collision
	test_transform = test_transform.translated(body_test_result.get_travel())	## Move test_transform by distance traveled before collision

	_debug_stair_step_up("SSU_REMAINING", remainder)												## DEBUG
	_debug_stair_step_up("SSU_TEST_POS", test_transform)											## DEBUG

	# 2. Move test_transform up to ceiling (if any)
	var step_up = MAX_STEP_UP * vertical
	body_test_params.from = test_transform
	body_test_params.motion = step_up
	PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result)
	test_transform = test_transform.translated(body_test_result.get_travel())

	_debug_stair_step_up("SSU_TEST_POS", test_transform)											## DEBUG

	# 3. Move test_transform forward by remaining distance
	body_test_params.from = test_transform
	body_test_params.motion = remainder
	PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result)
	test_transform = test_transform.translated(body_test_result.get_travel())

	_debug_stair_step_up("SSU_TEST_POS", test_transform)											## DEBUG

	# 3.5 Project remaining along wall normal (if any)
	## So you can walk into wall and up a step
	if body_test_result.get_collision_count() != 0:
		remainder = body_test_result.get_remainder().length()

		### Uh, there may be a better way to calculate this in Godot.
		var wall_normal = body_test_result.get_collision_normal()
		var dot_div_mag = wish_dir.dot(wall_normal) / (wall_normal * wall_normal).length()
		var projected_vector = (wish_dir - dot_div_mag * wall_normal).normalized()

		body_test_params.from = test_transform
		body_test_params.motion = remainder * projected_vector
		PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result)
		test_transform = test_transform.translated(body_test_result.get_travel())

		_debug_stair_step_up("SSU_TEST_POS", test_transform)										## DEBUG

	# 4. Move test_transform down onto step
	body_test_params.from = test_transform
	body_test_params.motion = MAX_STEP_UP * -vertical

	# Return if no collision
	if !PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result):
		_debug_stair_step_up("SSU_EXIT_2", null)													## DEBUG

		return

	test_transform = test_transform.translated(body_test_result.get_travel())
	_debug_stair_step_up("SSU_TEST_POS", test_transform)

	# 5. Check floor normal for un-walkable slope
	var surface_normal = body_test_result.get_collision_normal()
	print("SSU: Surface check: ", snappedf(surface_normal.angle_to(vertical), 0.001), " vs ", floor_max_angle)#!
	if (snappedf(surface_normal.angle_to(vertical), 0.001) > floor_max_angle):
		_debug_stair_step_up("SSU_EXIT_3", null)

		return
	print("SSU: Walkable")#!
	_debug_stair_step_up("SSU_TEST_POS", test_transform)

	# 6. Move player up
	var global_pos = global_position
	var step_up_dist = test_transform.origin.y - global_pos.y
	_debug_stair_step_up("SSU_APPLIED", step_up_dist)

	velocity.y = 0
	global_pos.y = test_transform.origin.y
	global_position = global_pos


func _debug_stair_step_down(param, value):
	if STEP_DOWN_DEBUG == false:
		return

	match param:
		"SSD_ENTER":
			print()
			print("Stair step down entered")
		"SSD_APPLIED":
			print("Stair step down applied, travel = ", value)

# Debug: Stair Step Up
func _debug_stair_step_up(param, value):
	if STEP_UP_DEBUG == false:
		return

	match param:
		"SSU_ENTER":
			print()
			print("SSU: Stair step up entered")
		"SSU_EXIT_1":
			print("SSU: Exited with no collisions")
		"SSU_TEST_POS":
			print("SSU: test_transform current position = ", value)
		"SSU_REMAINING":
			print("SSU: Remaining distance = ", value)
		"SSU_EXIT_2":
			print("SSU: Exited due to no step collision")
		"SSU_EXIT_3":
			print("SSU: Exited due to non-floor stepping")
		"SSU_APPLIED":
			print("SSU: Player moved up by ", value, " units")
