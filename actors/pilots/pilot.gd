class_name Pilot
extends Area3D

@onready var offscreen_marker := $OffscreenMarker as Node3D
@onready var offscreen_marker_material := $OffscreenMarker/Marker.material as ShaderMaterial
@onready var ship := get_parent() as Ship

var faction: Factions.Faction
var detected_pilots := {}


func _ready() -> void:
	ship.pilot = self
	# pilots want to set ship weapon loadouts in their _ready so ship must be ready beforehand
	await ship.ready
	offscreen_marker.visible = false
	offscreen_marker_material.set_shader_parameter(&"color", Factions.get_color(faction))


func _on_detection_radar_area_entered(area: Area3D) -> void:
	if area is Pilot and area != self:
		var pilot := area as Pilot
		detected_pilots[pilot] = true
		pilot.offscreen_marker.visible = true


func _on_tracking_radar_area_exited(area: Area3D) -> void:
	if area is Pilot:
		var pilot := area as Pilot
		detected_pilots.erase(pilot)
		pilot.offscreen_marker.visible = false
