extends Node3D

@onready var indicator := $Indicator as Sprite2D
@onready var camera := get_viewport().get_camera_3d() as InterpolatedCamera3D

var selection: Node3D  # Can be CollisionObject3D or VoxelLodTerrain


func _ready() -> void:
	indicator.visible = false


func _process(_delta: float) -> void:
	if selection:
		var selection_global_position := Utils.interpolated_global_position(selection)
		indicator.position = camera.unproject_position(selection_global_position)
		indicator.visible = not camera.is_position_behind(selection_global_position)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		var params := PhysicsRayQueryParameters3D.new()
		params.from = camera.project_ray_origin(Mouse.get_cursor_position())
		params.to = params.from + camera.project_ray_normal(Mouse.get_cursor_position()) * camera.far
		params.collision_mask = 0b1
		var result := get_world_3d().direct_space_state.intersect_ray(params)
		if result:
			if result.collider != selection:
				selection = result.collider
				Signals.selection_changed.emit(selection)
