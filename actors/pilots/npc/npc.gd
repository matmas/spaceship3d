class_name NPC
extends Pilot

var player: Player


func _on_detection_area_entered(area: Area3D) -> void:
	if area is Player:
		player = area as Player


func _on_tracking_area_exited(area: Area3D) -> void:
	if area == player:
		player = null
