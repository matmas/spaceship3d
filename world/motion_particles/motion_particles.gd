extends GPUParticles3D

@onready var camera := get_viewport().get_camera_3d()
@onready var previous_camera_position := camera.global_position

var camera_velocity := Vector3()


func _process(delta):
	global_transform = camera.global_transform
	var material := process_material as ParticleProcessMaterial
	material.color.a = min(camera_velocity.length(), 1.0)


func _physics_process(delta):
	camera_velocity = camera.global_position - previous_camera_position
	previous_camera_position = camera.global_position
