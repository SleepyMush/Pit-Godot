extends Node3D

@export var noise = FastNoiseLite.new()
var GENERATION_BOUND_DISTANCE = 32
const VIRTICAL_AMPLITUDE = 14
@onready var player = get_node("../Player")
var generated_cubes = {}
@onready var plane = $Plane

func _ready():
	generate_new_cubes_from_position(player.position)

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
		

func generate_new_cubes_from_position(player_position):
	for x in range(player_position.x - GENERATION_BOUND_DISTANCE, player_position.x + GENERATION_BOUND_DISTANCE):
		for z in range(player_position.z - GENERATION_BOUND_DISTANCE, player_position.z + GENERATION_BOUND_DISTANCE):
			var p_position = Vector3(x, 0, z)
			var distance_to_player = player_position.distance_to(p_position)
			if distance_to_player <= GENERATION_BOUND_DISTANCE:
				generate_cube_if_new(p_position.x, p_position.z)


func generate_cube_if_new(x,z):
	if !has_cube_been_Generated(x,z):
		var generated_noise = noise.get_noise_2d(x,z)
		plane.Generate_Mesh(Vector3(x ,generated_noise * VIRTICAL_AMPLITUDE, z), get_Color_From_Noise(generated_noise))
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
