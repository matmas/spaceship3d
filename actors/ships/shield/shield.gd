extends Node3D

@onready var camera := get_viewport().get_camera_3d()
@onready var ship := owner as Ship
@onready var bubble_material := $Bubble.get_surface_override_material(0) as ShaderMaterial
@onready var object_to_index := ObjectToIndex.new(NUM_LAST_IMPACTS)

const NUM_LAST_IMPACTS = 8
var last_impact_positions := PackedVector3Array()
var last_impact_alphas := PackedFloat32Array()


func _ready() -> void:
	ship.hit.connect(_process_hit)
	last_impact_alphas.resize(NUM_LAST_IMPACTS)
	last_impact_alphas.fill(0)
	last_impact_positions.resize(NUM_LAST_IMPACTS)
	last_impact_positions.fill(Vector3())


func _process(delta: float) -> void:
	for i in range(NUM_LAST_IMPACTS):
		last_impact_alphas[i] = move_toward(last_impact_alphas[i], 0, delta)
	bubble_material.set_shader_parameter("impact_positions", last_impact_positions)
	bubble_material.set_shader_parameter("impact_alphas", last_impact_alphas)


func _process_hit(weapon: Weapon) -> void:
	var params := PhysicsRayQueryParameters3D.new()
	params.collide_with_areas = true
	params.collide_with_bodies = false
	params.from = weapon.global_transform.origin
	params.to = params.from - weapon.global_transform.basis.z * camera.far
	params.collision_mask = 0b10
	var result := get_world_3d().direct_space_state.intersect_ray(params)
	var local_position := to_local(result.position) if result else Vector3()
	var index := object_to_index.get_index(weapon)
	last_impact_positions[index] = local_position
	last_impact_alphas[index] = 1.0
