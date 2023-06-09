extends Weapon

@onready var projectile_scene := preload("projectile.tscn")
@onready var fire := $Fire as AudioStreamPlayer3D

var delay_between_projectiles := 100.0
var last_projectile_fired_at := -INF


func _ready() -> void:
	super._ready()
	projectile_speed = 100.0


func _process(delta: float) -> void:
	super._process(delta)
	if try_firing:
		var now := Time.get_ticks_msec()
		if now - last_projectile_fired_at >= delay_between_projectiles:
			last_projectile_fired_at = now

			var projectile := projectile_scene.instantiate() as Projectile
			projectile.top_level = true
			projectile.weapon = self
			projectile.collision_mask = ray_cast.collision_mask
			projectile.linear_velocity = ship.linear_velocity + -global_transform.basis.z * projectile_speed
			projectile.max_travel_distance = projectile_max_travel_distance
			projectile.excluded_rids = [ship, ship.shield]
			add_child(projectile)

			fire.pitch_scale = randf_range(0.9, 1.1)
			fire.play()
