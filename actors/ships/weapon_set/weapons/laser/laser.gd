extends Weapon

@onready var beam := $Beam as MeshInstance3D
@onready var beam_scale := beam.scale
@onready var sparks := $Sparks as GPUParticles3D
@onready var smoke := $Smoke as GPUParticles3D
@onready var painter := $Painter as Painter
@onready var firing := $Firing as AudioStreamPlayer3D
@onready var firing_volume := firing.volume_db
@onready var hitting := $Hitting as AudioStreamPlayer3D
@onready var hitting_volume := hitting.volume_db

var power := 0.0


func _ready() -> void:
	super._ready()
	firing.volume_db = -INF
	hitting.volume_db = -INF
	can_focus = true


func _process(delta: float) -> void:
	super._process(delta)
	if try_firing:
		power = move_toward(power, 1.0, delta * 60 * 0.2)
	else:
		power = move_toward(power, 0.0, delta * 60 * 0.1)
	beam.visible = power > 0.0
	beam.scale.x = power * beam_scale.x
	beam.scale.y = power * beam_scale.y
	beam.set_instance_shader_parameter(&"instance_alpha", power)

	firing.volume_db = firing_volume + linear_to_db(lerpf(db_to_linear(firing.volume_db), power, 1 - pow(0.1, delta * 5)))
	hitting.volume_db = hitting_volume if ray_cast.is_colliding() and power > 0.0 else -INF
	hitting.global_position = ray_cast.get_collision_point()

	var beam_endpoint := _collision_point_or_target_position()
	for p in [sparks, smoke]:
		var particles := p as GPUParticles3D
		if particles == smoke and not ray_cast.get_collider() is Rock:
			continue
		particles.emitting = ray_cast.is_colliding() and power == 1.0
		if ray_cast.is_colliding() and power == 1.0:
			particles.global_position = beam_endpoint
			if not Vector3.UP.cross(ray_cast.get_collision_normal()).is_zero_approx():
				particles.look_at(beam_endpoint + ray_cast.get_collision_normal())

	beam.look_at(beam_endpoint, beam.global_position - camera.global_position)  # rotate bottom towards camera
	beam.scale.z = global_position.distance_to(beam_endpoint)

	if ray_cast.is_colliding() and power == 1.0 and not ray_cast.get_collider() is Shield:
		painter.paint_line_on(ray_cast.get_collider() as CollisionObject3D, global_transform)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if ray_cast.is_colliding() and power == 1.0:
		if ray_cast.get_collider() is Hittable:
			var hittable := ray_cast.get_collider() as Hittable
			hittable.hit.emit(self, ray_cast.get_collision_point())
