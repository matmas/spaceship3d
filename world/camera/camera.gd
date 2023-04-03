extends Camera3D

@onready var target: Node3D = Globals.player.get_node("Bob")
@onready var collision_exclude := Globals.player

var camera_distance := 10.0
var camera_relative_direction := Vector3(0.0, 2.0, -10.0).normalized()
var current_target_camera_position: Vector3
var previous_target_camera_position: Vector3


func _ready():
	global_transform = _target_camera_transform()


func _process(delta: float):
	global_transform = global_transform.interpolate_with(_target_camera_transform(), delta * 10)


func _target_camera_transform() -> Transform3D:
	var f := Engine.get_physics_interpolation_fraction()
	var target_camera_position := previous_target_camera_position.lerp(current_target_camera_position, f)
	var target_camera_basis = target.global_transform.rotated_local(Vector3.UP, TAU / 2).basis
	return Transform3D(target_camera_basis, target_camera_position)


func _physics_process(_delta):
	previous_target_camera_position = current_target_camera_position
	current_target_camera_position = _calculate_target_camera_position()


func _calculate_target_camera_position() -> Vector3:
	var farthest_point := target.global_transform * (camera_relative_direction * camera_distance)
	var space_state = get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.new()
	params.from = target.global_position
	params.to = farthest_point
	params.exclude = [collision_exclude]
	var result := space_state.intersect_ray(params)
	if result:
		return result["position"]
	else:
		return farthest_point


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			camera_distance -= 1.0
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			camera_distance += 1.0
		camera_distance = clamp(camera_distance, 5.0, 50.0)
