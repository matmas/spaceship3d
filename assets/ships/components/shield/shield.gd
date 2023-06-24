class_name Shield
extends Hittable

@onready var bubble_material := $Bubble.get_surface_override_material(0) as ShaderMaterial
@onready var object_to_index := ObjectToIndex.new(NUM_LAST_IMPACTS)

const NUM_LAST_IMPACTS = 32
var last_impact_directions := PackedVector3Array()
var last_impact_alphas := PackedFloat32Array()


func _ready() -> void:
	super._ready()
	last_impact_alphas.resize(NUM_LAST_IMPACTS)
	last_impact_alphas.fill(0)
	last_impact_directions.resize(NUM_LAST_IMPACTS)
	last_impact_directions.fill(Vector3())


func _process(delta: float) -> void:
	global_transform.basis = Basis()  # maintain the same world space orientation

	var all_alpha_zero := true
	for i in range(NUM_LAST_IMPACTS):
		var alpha := move_toward(last_impact_alphas[i], 0, delta)
		if alpha > 0:
			all_alpha_zero = false
		last_impact_alphas[i] = alpha
	bubble_material.set_shader_parameter(&"impact_alphas", last_impact_alphas)

	if all_alpha_zero:
		set_process(false)


func _process_hit(weapon: Weapon, source: Node3D, impact_point: Vector3) -> void:
	super._process_hit(weapon, source, impact_point)
	var index := object_to_index.get_index(source)
	last_impact_directions[index] = to_local(impact_point).normalized()
	bubble_material.set_shader_parameter(&"impact_directions", last_impact_directions)
	last_impact_alphas[index] = 1.0
	set_process(true)
