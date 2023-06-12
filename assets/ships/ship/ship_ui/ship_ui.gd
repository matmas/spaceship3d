extends Control

@onready var selection := $Selection as NinePatchRect
@onready var ship := owner.owner as Ship
@onready var camera := get_viewport().get_camera_3d()

const MIN_SIZE = 64


func _process(_delta: float) -> void:
	visible = not camera.is_position_behind(ship.mesh_instance.global_position)
	if visible:
		var rect := Utils.unproject_aabb_to_screen_space_rect(ship.mesh_instance, camera)
		rect = Utils.make_square(rect, MIN_SIZE)
		position = rect.position
		size = rect.size
		modulate = Factions.get_color(ship.pilot.faction)
