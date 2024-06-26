extends CharacterBody3D

#Player's Varibales
var Current_Speed
const walking_speed = 5.0
const sprinting_speed = 8
const Jump_velocity = 4.5

const mouse_sens = 0.1

#Annotations/Nodes
@onready var head = $Head

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))

func _physics_process(delta):
	#State
	if Input.is_action_pressed("Sprint"):
		Current_Speed = sprinting_speed
	else:
		Current_Speed = walking_speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = Jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * Current_Speed
		velocity.z = direction.z * Current_Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Current_Speed)
		velocity.z = move_toward(velocity.z, 0, Current_Speed)

	move_and_slide()
