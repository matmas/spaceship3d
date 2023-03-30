extends TextureRect

@onready var directional_light: DirectionalLight3D = get_parent()


func _process(_delta):
	var camera := get_viewport().get_camera_3d()
	var effective_sun_direction: Vector3 = directional_light.global_transform.basis.z * maxf(camera.near, 1.0)
	effective_sun_direction += camera.global_transform.origin

	visible = not camera.is_position_behind(effective_sun_direction)

	if visible:
		var unprojected_sun_position: Vector2 = camera.unproject_position(effective_sun_direction)
		var shader := material as ShaderMaterial
		shader.set_shader_parameter("sun_position", unprojected_sun_position)
