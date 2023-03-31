extends TextureRect

@onready var camera: Camera3D = get_viewport().get_camera_3d()
@onready var directional_light: DirectionalLight3D = get_parent()


func get_light_apparent_global_position() -> Vector3:
	return camera.global_position + directional_light.global_transform.basis.z * camera.far


func _process(_delta):
#	visible = not camera.is_position_behind(effective_sun_direction)
#	if not camera.is_position_behind(effective_sun_direction):
	var unprojected_sun_position: Vector2 = camera.unproject_position(get_light_apparent_global_position())
	var shader := material as ShaderMaterial
	shader.set_shader_parameter("sun_position", unprojected_sun_position)


func _physics_process(delta):
	var space_state = directional_light.get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.new()
	params.from = camera.global_position
	params.to = get_light_apparent_global_position()
	var result := space_state.intersect_ray(params)
	visible = false if result else true
