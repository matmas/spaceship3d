extends Control

@onready var selection := $Selection as NinePatchRect
@onready var label := $Label as Label
@onready var camera := get_viewport().get_camera_3d() as InterpolatedCamera3D

var visual_instance: VisualInstance3D
var body: RigidBody3D

const MIN_SIZE = 64


func _ready() -> void:
	visual_instance = Utils.get_visual_instance_ancestor(self)
	body = Utils.get_rigid_body_ancestor(self)


func _process(_delta: float) -> void:
	visible = not camera.is_position_behind(visual_instance.global_position)
	if visible:
		var rect := Utils.unproject_aabb_to_screen_space_rect(visual_instance, camera)
		rect = Utils.make_square(rect, MIN_SIZE)
		position = rect.position
		size = rect.size

		var distance := "%.0f m" % camera.target.global_position.distance_to(visual_instance.global_position)
		var velocity := ""
		if body is RigidBody3D:
			var body_ := body as RigidBody3D
			velocity = "%.0f m/s" % body_.linear_velocity.length()
		label.text = "%s\n%s\n%s" % [body.name, distance, velocity]

		if visual_instance.owner is Ship:
			var ship := visual_instance.owner as Ship
			modulate = Factions.get_color(ship.pilot.faction)
