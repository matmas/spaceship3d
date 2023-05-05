extends Node3D

@onready var indicator := $Indicator as Sprite2D
@onready var label := $Indicator/Label as Label
@onready var camera := get_viewport().get_camera_3d()

var collider: CollisionObject3D


func _ready() -> void:
	indicator.visible = false


func _process(_delta: float) -> void:
	if collider:
		var collider_global_position := get_collider_global_position()
		indicator.position = camera.unproject_position(collider_global_position)
		indicator.visible = not camera.is_position_behind(collider_global_position)
		label.visible = indicator.visible
		if collider is RigidBody3D:
			var body := collider as RigidBody3D
			label.text = "%s: %s m/s" % [collider.name, body.linear_velocity.length()]
		else:
			label.text = collider.name


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		var params := PhysicsRayQueryParameters3D.new()
		params.from = camera.project_ray_origin(Mouse.get_cursor_position())
		params.to = params.from + camera.project_ray_normal(Mouse.get_cursor_position()) * camera.far
		var result := get_world_3d().direct_space_state.intersect_ray(params)
		if result:
			collider = result.collider


func get_collider_global_position() -> Vector3:
	for child in collider.get_children():
		if child is MeshInstance3D:
			# prefer physics interpolated mesh instance over jittery collision object
			return (child as MeshInstance3D).global_position
	return collider.global_position
