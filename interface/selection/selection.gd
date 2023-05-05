extends Sprite2D

@onready var node_3d := $Node3D as Node3D
@onready var label := $Label as Label
@onready var camera := get_viewport().get_camera_3d()

var collider: CollisionObject3D


func _ready() -> void:
	visible = false


func _process(_delta: float) -> void:
	if collider:
		position = camera.unproject_position(collider.global_position)
		visible = not camera.is_position_behind(collider.global_position)
		label.visible = visible
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
		var result := node_3d.get_world_3d().direct_space_state.intersect_ray(params)
		if result:
			collider = result.collider
