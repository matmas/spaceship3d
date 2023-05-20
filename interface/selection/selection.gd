extends Node3D

@onready var indicator := $Indicator as Sprite2D
@onready var label := $Indicator/Label as Label
@onready var camera := get_viewport().get_camera_3d() as InterpolatedCamera3D

var selected: CollisionObject3D


func _ready() -> void:
	indicator.visible = false


func _process(_delta: float) -> void:
	if selected:
		var selected_global_position := get_selected_global_position()
		indicator.position = camera.unproject_position(selected_global_position)
		indicator.visible = not camera.is_position_behind(selected_global_position)
		label.visible = indicator.visible
		var distance := "%.0f m" % camera.target.global_position.distance_to(selected_global_position)
		var velocity := ""
		if selected is RigidBody3D:
			var body := selected as RigidBody3D
			velocity = "%.0f m/s" % body.linear_velocity.length()
		label.text = "%s\n%s\n%s" % [selected.name, distance, velocity]


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		var params := PhysicsRayQueryParameters3D.new()
		params.from = camera.project_ray_origin(Mouse.get_cursor_position())
		params.to = params.from + camera.project_ray_normal(Mouse.get_cursor_position()) * camera.far
		params.collision_mask = 0b1
		var result := get_world_3d().direct_space_state.intersect_ray(params)
		if result:
			selected = result.collider


func get_selected_global_position() -> Vector3:
	for child in selected.get_children():
		if child is MeshInstance3D:
			# prefer physics interpolated mesh instance over jittery collision object
			return (child as MeshInstance3D).global_position
	return selected.global_position
