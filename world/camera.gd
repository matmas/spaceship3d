extends Camera3D

@onready var target: Node3D = $"../Bob/Bob/CameraPosition"


func _ready():
	global_transform = target.global_transform


func _process(delta: float):
	global_transform = global_transform.interpolate_with(target.global_transform, delta * 10)
