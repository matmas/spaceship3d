extends Weapon

var bullet_scene := preload("bullet.tscn")

var cooldown := 1.0

func _process(_delta: float) -> void:
	if is_firing:
		var bullet := bullet_scene.instantiate() as RigidBody3D
		bullet.top_level = true
		bullet.linear_velocity = -global_transform.basis.z * 10000
		add_child(bullet)
		bullet.global_position += -global_transform.basis.z * 10
