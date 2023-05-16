extends Weapon

@onready var bullet_scene := preload("bullet.tscn")

var cooldown := 100.0
var bullet_velocity := 100.0
var last_bullet_fired_at := -INF


func _process(delta: float) -> void:
	super._process(delta)
	if is_firing:
		var now := Time.get_ticks_msec()
		if now - last_bullet_fired_at > cooldown:
			last_bullet_fired_at = now

			var bullet := bullet_scene.instantiate() as Bullet
			bullet.top_level = true
			bullet.weapon = self
			bullet.collision_mask = ray_cast.collision_mask
			bullet.linear_velocity = ship.linear_velocity + -global_transform.basis.z * bullet_velocity
			bullet.excluded_rids = [ship]
			add_child(bullet)
