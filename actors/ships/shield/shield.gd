extends Area3D

var impact_scene := preload("res://actors/ships/shield/impact.tscn")

@onready var radius := (($CollisionShape3D as CollisionShape3D).shape as SphereShape3D).radius
@onready var shape_cast := $ShapeCast as ShapeCast3D

var impacts := {}


func _ready() -> void:
	shape_cast.add_exception(owner)


func _on_body_entered(body: Node3D) -> void:
	if body.global_position.is_equal_approx(global_position):
		return

	var impact := impact_scene.instantiate() as Node
	add_child(impact)
	impacts[body] = impact


func _on_body_exited(body: Node3D) -> void:
	var impact := impacts.get(body) as Node
	if impact:
		remove_child(impact)
		impacts.erase(body)
		impact.queue_free()


func _physics_process(_delta: float) -> void:
	for i in range(shape_cast.get_collision_count()):
		var collider := shape_cast.get_collider(i) as CollisionObject3D
		for node in impacts:
			if collider == node:
				(impacts[node] as Node3D).global_position = shape_cast.get_collision_point(i)
