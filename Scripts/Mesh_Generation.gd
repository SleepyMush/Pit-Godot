extends MeshInstance3D

func Generate_Mesh(_position, color):
	var mesh = MeshInstance3D.new()
	var plane_size = Vector3(1, 1, 1)
	var static_body = StaticBody3D.new()
	var collision_shape3D = CollisionShape3D.new()
	
	var vertices = PackedVector3Array()
	vertices.push_back(Vector3(0, 0, 0))
	vertices.push_back(Vector3(1, 0, 0))
	vertices.push_back(Vector3(1, 0, 1))
	vertices.push_back(Vector3(0, 0, 1))
	
	var indices := PackedInt32Array(
		[
		0,1,2,
		0,2,3
		]
	)
	
	var uvs = PackedVector2Array()
	uvs.push_back(Vector2(0, 0))
	uvs.push_back(Vector2(1, 0))
	uvs.push_back(Vector2(1, 1))
	uvs.push_back(Vector2(0, 1))
	
	var surface = SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(vertices.size()):
		surface.set_uv(uvs[i])
		surface.add_vertex(vertices[i])
	for i in indices:
		surface.add_index(i)
	
	surface.generate_normals()
	var custom_mesh = surface.commit()
	mesh.mesh = custom_mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	mesh.set_surface_override_material(0, material)
	
	collision_shape3D.transform.origin = _position
	collision_shape3D.shape = BoxShape3D.new()
	collision_shape3D.shape.size = plane_size
	
	static_body.add_child(collision_shape3D)
	add_child(static_body)
	
	mesh.transform.origin = _position
	add_child(mesh)
