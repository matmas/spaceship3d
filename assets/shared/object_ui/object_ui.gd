extends Control

@onready var selection := $Selection as NinePatchRect
@onready var label := $Label as Label
@onready var camera := get_viewport().get_camera_3d()

var visual_instance: VisualInstance3D

const MIN_SIZE = 64


func _ready() -> void:
	visual_instance = _get_visual_instance_ancestor()


func _process(_delta: float) -> void:
	visible = not camera.is_position_behind(visual_instance.global_position)
	if visible:
		var rect := Utils.unproject_aabb_to_screen_space_rect(visual_instance, camera)
		rect = Utils.make_square(rect, MIN_SIZE)
		position = rect.position
		size = rect.size

		if visual_instance.owner is Ship:
			var ship := visual_instance.owner as Ship
			modulate = Factions.get_color(ship.pilot.faction)


func _get_visual_instance_ancestor() -> VisualInstance3D:
	var parent := get_parent()
	while parent != null:
		if parent is VisualInstance3D:
			return parent as VisualInstance3D
		parent = parent.get_parent()
	return null
