extends TextureRect

@onready var camera: Camera3D = get_viewport().get_camera_3d()
@onready var directional_light: DirectionalLight3D = get_parent()


var visibility := 0.0
var target_visibility := 0.0


func get_light_apparent_global_position() -> Vector3:
	return camera.global_position + directional_light.global_transform.basis.z * camera.far


func _process(delta):
	var shader := material as ShaderMaterial
	shader.set_shader_parameter("sun_position", camera.unproject_position(get_light_apparent_global_position()))
	shader.set_shader_parameter("visibility", visibility)
	visibility = lerp(visibility, target_visibility, delta * 10)
	visible = not camera.is_position_behind(get_light_apparent_global_position())


func _physics_process(_delta):
	var space_state = directional_light.get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.new()
	params.from = camera.global_position
	params.to = get_light_apparent_global_position()
	var result := space_state.intersect_ray(params)
	target_visibility = 0.0 if result else 1.0
