extends Weapon

@onready var bullet_scene := preload("bullet.tscn")
@onready var ship := owner.owner as Ship

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
			bullet.linear_velocity = ship.linear_velocity + -global_transform.basis.z * bullet_velocity
			bullet.excluded_rids = [ship.get_rid()]
			add_child(bullet)
