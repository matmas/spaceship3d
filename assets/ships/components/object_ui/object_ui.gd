class_name ObjectUI
extends Control

@onready var selection := $Selection as NinePatchRect
@onready var label := $Label as Label
@onready var camera := get_viewport().get_camera_3d() as InterpolatedCamera3D
@onready var visual_instance_ancestor := Utils.get_visual_instance_ancestor(self)
@onready var ship := Utils.get_rigid_body_ancestor(self) as Ship
@onready var hull_integrity_bar := $HullIntegrityBar as TextureProgressBar
@onready var shield_integrity_bar := $ShieldIntegrityBar as TextureProgressBar


func _ready() -> void:
	await ship.ready
	hull_integrity_bar.value = 100.0
	shield_integrity_bar.value = 100.0
	ship.hit.connect(_process_ship_hit)
	ship.shield.hit.connect(_process_shield_hit)


func _process(_delta: float) -> void:
	visible = not camera.is_position_behind(visual_instance_ancestor.global_position)
	if visible:
		var rect := Utils.unproject_aabb_to_screen_space_rect(visual_instance_ancestor, camera)
		if rect:
			const MIN_SIZE = 64
			rect = Utils.make_square(rect, MIN_SIZE)
			position = rect.position
			size = rect.size

			var distance := "%.0f m" % camera.target.global_position.distance_to(visual_instance_ancestor.global_position)
			var velocity = "%.0f m/s" % ship.linear_velocity.length()
			label.text = "%s\n%s\n%s" % [ship.name, distance, velocity]
		else:
			visible = false


func set_color(color: Color):
	selection.modulate = color
	label.modulate = color
	hull_integrity_bar.self_modulate = color


func _process_ship_hit(_weapon: Weapon, _source: Node3D, _impact_point: Vector3) -> void:
	ship.object_ui.hull_integrity_bar.max_value = ship.max_integrity
	ship.object_ui.hull_integrity_bar.value = ship.integrity


func _process_shield_hit(_weapon: Weapon, _source: Node3D, _impact_point: Vector3) -> void:
	ship.object_ui.shield_integrity_bar.max_value = ship.shield.max_integrity
	ship.object_ui.shield_integrity_bar.value = ship.shield.integrity
