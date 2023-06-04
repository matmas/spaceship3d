class_name Projectile
extends Node3D

@onready var mesh_instance := $MeshInstance as MeshInstance3D
@onready var sparks := $Sparks as GPUParticles3D
@onready var smoke := $Smoke as GPUParticles3D
@onready var camera := get_viewport().get_camera_3d()
@onready var initial_global_position := global_position
@onready var impact_shield := $ImpactShield as AudioStreamPlayer3D
@onready var flying := $Flying as AudioStreamPlayer3D


var linear_velocity := Vector3()
var excluded_rids: Array[RID] = []
var weapon: Weapon
var params := PhysicsRayQueryParameters3D.new()
var collision_mask: int
var max_travel_distance: float

func _ready() -> void:
	flying.pitch_scale = randf_range(0.9, 1.1)


func _process(delta: float) -> void:
	params.from = global_position
	params.to = global_position + linear_velocity * delta
	params.collision_mask = collision_mask
	params.exclude = excluded_rids
	var result := get_world_3d().direct_space_state.intersect_ray(params)
	if result:
		global_position = result.position
		if result.collider is Hittable:
			var hittable: Hittable = result.collider
			hittable.hit.emit(self, result.position)

			if hittable is Shield:
				impact_shield.pitch_scale = randf_range(0.8, 2.0)
				impact_shield.play()
			flying.stop()

			for p in [sparks, smoke]:
				var particles := p as GPUParticles3D
				if particles == smoke and not hittable is Rock:
					continue
				particles.emitting = true
				if not Vector3.UP.cross(result.normal).is_zero_approx():
					particles.look_at(result.position + result.normal)
		set_process(false)
		mesh_instance.visible = false
		await get_tree().create_timer(maxf(maxf(sparks.lifetime, smoke.lifetime), impact_shield.stream.get_length())).timeout
		queue_free()
	else:
		global_position = params.to
		if initial_global_position.distance_squared_to(global_position) > pow(max_travel_distance, 2):
			queue_free()
