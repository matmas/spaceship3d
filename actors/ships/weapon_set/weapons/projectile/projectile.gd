extends Weapon

@onready var bullet_scene := preload("bullet.tscn")

var cooldown := 0.0
var bullet_velocity := 10000.0
var last_bullet_fired_at := -INF


func _process(_delta: float) -> void:
	if is_firing:
		var now := Time.get_ticks_msec()
		if now - last_bullet_fired_at > cooldown:
			last_bullet_fired_at = now
			var bullet := bullet_scene.instantiate() as Bullet
			bullet.top_level = true
			bullet.linear_velocity = -global_transform.basis.z * bullet_velocity
			add_child(bullet)
