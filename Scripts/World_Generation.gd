extends Node

var noise
var GENERATION_BOUND_DISTANCE = 32
const VIRTICAL_AMPLITUDE = 14
var player
var generated_cubes

func _ready():
	generated_cubes = {}
	noise = FastNoiseLite.new()
	player = get_node("../Player")
	generate_new_cubes_from_position(player.position)
	

func _physics_process(_delta):
	pass

func _process(_delta):
	generate_new_cubes_from_position(player.position)

func get_Color_From_Noise(noise_value):
	if noise_value <= -.4:
		return Color(1,0,0,1)
	elif noise_value <= -.2:
		return Color(0,1,0,1)
	elif noise_value <= 0:
		return Color(0,0,1,1)
	elif noise_value <= .2:
		return Color(.5,.5,.5,1)
	elif noise_value > .2:
		return Color(.3,.8,.5,1)
		

func createCube(position, color):
	var box_size = Vector3(1,1,1)
	var static_body = StaticBody3D.new()
	var collison_shape3D = CollisionShape3D.new()
	
	collison_shape3D.position = position
	collison_shape3D.shape = BoxShape3D.new()
	collison_shape3D.shape.size = box_size
	
	var mesh = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = box_size
	
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	box_mesh.material = material
	
	mesh.set_mesh(box_mesh)
	mesh.set_position(position)
	
	static_body.add_child(mesh)
	static_body.add_child(collison_shape3D)
	
	add_child(static_body)

func generate_new_cubes_from_position(player_position):
	for x in range(player_position.x - GENERATION_BOUND_DISTANCE, player_position.x + GENERATION_BOUND_DISTANCE):
		for z in range(player_position.z - GENERATION_BOUND_DISTANCE, player_position.z + GENERATION_BOUND_DISTANCE):
			var position = Vector3(x, 0, z)
			var distance_to_player = player_position.distance_to(position)
			if distance_to_player <= GENERATION_BOUND_DISTANCE:
				generate_cube_if_new(position.x, position.z)


func generate_cube_if_new(x,z):
	if !has_cube_been_Generated(x,z):
		var generated_noise = noise.get_noise_2d(x,z)
		createCube(Vector3(x,generated_noise * VIRTICAL_AMPLITUDE, z), get_Color_From_Noise(generated_noise))
		register_cube_generation_at_coordinate(x,z)


func has_cube_been_Generated(x,z):
	if x in generated_cubes and z in generated_cubes[x] and generated_cubes[x][z] == true:
		return true
	else:
		return false
	

func register_cube_generation_at_coordinate(x,z):
	if x in generated_cubes:
		generated_cubes[x][z] = true
	else:
		generated_cubes[x] = {z: true}  


