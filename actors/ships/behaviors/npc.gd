class_name NPC
extends Ship

var player: Player


func _on_detection_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body as Player


func _on_tracking_body_exited(body: Node3D) -> void:
	if body == player:
		player = null
