extends Camera3D

@onready var target_mesh := Globals.player.get_node("Bob") as MeshInstance3D
@onready var target_body := Globals.player as PhysicsBody3D

var camera_distance := 10.0
var camera_relative_direction := Vector3(0.0, 2.0, 10.0).normalized()
var current_camera_position: Vector3
var previous_camera_position: Vector3


func _ready() -> void:
	global_transform = _target_camera_transform()


func _process(delta: float) -> void:
	global_transform = global_transform.interpolate_with(_target_camera_transform(), 1 - pow(0.1, delta * 2))


func _target_camera_transform() -> Transform3D:
	var target_camera_basis = target_mesh.global_transform.basis
	return Transform3D(target_camera_basis, _current_camera_position())


func _physics_process(_delta: float) -> void:
	previous_camera_position = _current_camera_position()
	current_camera_position = _calculate_target_camera_position()


func _default_camera_position() -> Vector3:
	var top := Vector3(0, target_mesh.get_aabb().size.y * 0.5, 0)
	return target_mesh.global_transform * (top + camera_relative_direction * camera_distance)


func _current_camera_position() -> Vector3:
	if current_camera_position:
		if Engine.is_in_physics_frame():
			return current_camera_position
		else:
			var f := Engine.get_physics_interpolation_fraction()
			return previous_camera_position.lerp(current_camera_position, f)
	else:
		return _default_camera_position()


func _calculate_target_camera_position() -> Vector3:
	var space_state = get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.new()
	params.from = target_body.global_position
	params.to = _default_camera_position()
	params.exclude = [target_body]
	var result := space_state.intersect_ray(params)
	if result:
		return result.position
	else:
		return Vector3()  # we'll use _default_camera_position() later


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_released(&"dolly_in"):
		camera_distance -= 5
	if Input.is_action_just_released(&"dolly_out"):
		camera_distance += 5
	camera_distance = clampf(camera_distance, 5.0, 50.0)
