extends TextureRect

@onready var camera := get_viewport().get_camera_3d()
@onready var directional_light := get_parent() as DirectionalLight3D
@onready var shader_material := material as ShaderMaterial

var visibility := 0.0
var target_visibility := 0.0


func _ready() -> void:
	set_process(visible)
	set_physics_process(visible)


func get_light_apparent_global_position() -> Vector3:
	return camera.global_position + directional_light.global_transform.basis.z * camera.far


func _process(delta: float) -> void:
	visible = not camera.is_position_behind(get_light_apparent_global_position())
	if visible:
		shader_material.set_shader_parameter(&"sun_position", camera.unproject_position(get_light_apparent_global_position()))
		shader_material.set_shader_parameter(&"visibility", visibility)
		visibility = lerpf(visibility, target_visibility, 1 - pow(0.1, delta * 5))


func _physics_process(_delta: float) -> void:
	var space_state = directional_light.get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.new()
	params.from = camera.global_position
	params.to = get_light_apparent_global_position()
	params.collision_mask = 0b1
	var result := space_state.intersect_ray(params)
	target_visibility = 0.0 if result else 1.0
