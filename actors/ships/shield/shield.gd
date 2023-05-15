extends Node3D

@onready var camera := get_viewport().get_camera_3d()
@onready var ship := owner as Ship
@onready var bubble_material := $Bubble.get_surface_override_material(0) as ShaderMaterial
@onready var object_to_index := ObjectToIndex.new(NUM_LAST_IMPACTS)
@onready var shield_radius := (($Area3D/CollisionShape3D as CollisionShape3D).shape as SphereShape3D).radius


const NUM_LAST_IMPACTS = 8
var last_impact_directions := PackedVector3Array()
var last_impact_alphas := PackedFloat32Array()


func _ready() -> void:
	ship.hit.connect(_process_hit)
	last_impact_alphas.resize(NUM_LAST_IMPACTS)
	last_impact_alphas.fill(0)
	last_impact_directions.resize(NUM_LAST_IMPACTS)
	last_impact_directions.fill(Vector3())


func _process(delta: float) -> void:
	for i in range(NUM_LAST_IMPACTS):
		last_impact_alphas[i] = move_toward(last_impact_alphas[i], 0, delta)
	bubble_material.set_shader_parameter(&"impact_alphas", last_impact_alphas)


func _process_hit(weapon: Node3D, impact_direction: Vector3, impact_point: Vector3) -> void:
	var params := PhysicsRayQueryParameters3D.new()
	params.collide_with_areas = true
	params.collide_with_bodies = false
	var safe_distance_from_shield := shield_radius * 2
	params.from = impact_point - impact_direction * safe_distance_from_shield
	params.to = impact_point
	params.collision_mask = 0b10
	var result := get_world_3d().direct_space_state.intersect_ray(params)
	if result:
		var shield_impact_point: Vector3 = result.position
		var index := object_to_index.get_index(weapon)
		last_impact_directions[index] = to_local(shield_impact_point).normalized()
		bubble_material.set_shader_parameter(&"impact_directions", last_impact_directions)
		last_impact_alphas[index] = 1.0
