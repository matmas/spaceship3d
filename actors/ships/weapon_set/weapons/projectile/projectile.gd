extends Weapon

@onready var bullet_scene := preload("bullet.tscn")

var cooldown := 1.0
var bullet_velocity := 10.0


func _process(_delta: float) -> void:
	if is_firing:
		var bullet := bullet_scene.instantiate() as Bullet
		bullet.top_level = true
		bullet.linear_velocity = -global_transform.basis.z * bullet_velocity
		add_child(bullet)
