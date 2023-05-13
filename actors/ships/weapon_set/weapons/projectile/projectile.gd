extends Weapon

@onready var bullet_multimesh: MultiMeshInstance3D = $BulletMultimesh
@onready var exclude := [owner.owner]

var cooldown := 1.0
var bullet_velocity := 10.0
var bullets := {}


func _ready() -> void:
	bullet_multimesh.top_level = true


func _process(delta: float) -> void:
	if is_firing:
		bullets[Bullet.new(global_transform, -global_transform.basis.z * bullet_velocity, [], get_world_3d())] = true

	for bullet in bullets:
		if bullet.move_and_collide(delta):
			bullets.erase(bullet)

	bullet_multimesh.multimesh.instance_count = bullets.size()
	var i := 0
	for bullet in bullets:
		bullet_multimesh.multimesh.set_instance_transform(i, bullet.transform)
		i += 1
