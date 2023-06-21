class_name Ship
extends Hittable

@onready var mesh_instance := $Mesh as MeshInstance3D
@onready var weapon_set := $Mesh/WeaponSet as WeaponSet
@onready var shield := $Mesh/Shield as Shield

var pilot: Pilot
var linear_acceleration_to_apply := Vector3()


func _ready() -> void:
	can_sleep = false
	gravity_scale = 0
	linear_damp = 1
	angular_damp = 2
	inertia = Vector3(mass, mass, mass)  # disable automatic calculation of inertia from collision shapes
	contact_monitor = true
	max_contacts_reported = 2
	for i in range(max_contacts_reported):
		var sparks := preload("res://assets/shared/sparks/sparks.tscn").instantiate()
		sparks.name = "Sparks%d" % i
		add_child(sparks)


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	for i in range(max_contacts_reported):
		var sparks := get_node("Sparks%d" % i) as GPUParticles3D
		var is_contact := i < state.get_contact_count()
		sparks.emitting = is_contact
		if is_contact:
			var contact_point := state.get_contact_local_position(i)
			var contact_normal := state.get_contact_local_normal(i)
			sparks.global_position = contact_point
			if not Vector3.UP.cross(contact_point + contact_normal - sparks.global_position).is_zero_approx():
				sparks.look_at(contact_point + contact_normal)


func _physics_process(_delta: float) -> void:
	apply_central_force(to_global(to_local(linear_acceleration_to_apply).clamp(-max_linear_acceleration(), max_linear_acceleration())))
	linear_acceleration_to_apply = Vector3.ZERO


func max_linear_acceleration() -> Vector3:
	return Vector3(10, 10, 30) * mass


func max_angular_acceleration() -> Vector3:
	return Vector3(2, 2, 2) * mass
