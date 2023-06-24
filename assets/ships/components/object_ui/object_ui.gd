class_name ObjectUI
extends Control

@onready var selection := $Selection as NinePatchRect
@onready var label := $Label as Label
@onready var camera := get_viewport().get_camera_3d() as InterpolatedCamera3D
@onready var visual_instance_ancestor := Utils.get_visual_instance_ancestor(self)
@onready var rigid_body_ancestor := Utils.get_rigid_body_ancestor(self)
@onready var hull_integrity_bar := $HullIntegrityBar as TextureProgressBar
@onready var shield_integrity_bar := $ShieldIntegrityBar as TextureProgressBar


func _ready() -> void:
	hull_integrity_bar.value = 100.0
	shield_integrity_bar.value = 100.0


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
			var velocity = "%.0f m/s" % rigid_body_ancestor.linear_velocity.length()
			label.text = "%s\n%s\n%s" % [rigid_body_ancestor.name, distance, velocity]
		else:
			visible = false


func set_color(color: Color):
	selection.modulate = color
	label.modulate = color
	hull_integrity_bar.self_modulate = color
