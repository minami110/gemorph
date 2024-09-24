extends CharacterBody3D


const MOVE_SPEED = 5.0
const JUMP_VELOCITY = 4.5

const CAMERA_MOVE_SPEED_X = 0.5
const CAMERA_MOVE_SPEED_Y = 0.5

func _enter_tree() -> void:
	# Hide mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	DisplayServer.window_set_size(Vector2i(1280, 960))
	var pos = DisplayServer.window_get_position()
	DisplayServer.window_set_position(pos + Vector2i(-480, -360))

func _ready() -> void:
	%FocusArea.focus_entity_changed.connect(_on_FocusArea_focus_entity_changed)

func _physics_process(delta: float) -> void:
	# If Show Terminal skip
	if $Terminal.visible:
		return

	# Update Position
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Crouching
	var crouch_speed_scale := 1.0
	if Input.is_action_pressed("Crouch"):
		crouch_speed_scale = 0.333
		$Head.position.y = 0.0
	else:
		$Head.position.y = 0.4

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * MOVE_SPEED * crouch_speed_scale
		velocity.z = direction.z * MOVE_SPEED * crouch_speed_scale
	else:
		velocity.x = move_toward(velocity.x, 0, MOVE_SPEED * crouch_speed_scale)
		velocity.z = move_toward(velocity.z, 0, MOVE_SPEED * crouch_speed_scale)

	move_and_slide()

func _input(event: InputEvent) -> void:
	# Update camera direction
	if event is InputEventMouseMotion:
		# Update Camera rotation
		var rotx = %Camera.rotation_degrees.x - event.relative.y * CAMERA_MOVE_SPEED_Y
		rotx = clamp(rotx, -89, 89)
		%Camera.rotation_degrees.x = rotx

		# Update Player rotation
		self.rotation_degrees.y -= event.relative.x * CAMERA_MOVE_SPEED_Y
	

func _on_FocusArea_focus_entity_changed(entity: Node3D) -> void:
	$Terminal.set_target_entity(entity)

