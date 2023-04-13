extends TextureRect

@onready var uv_scope := $"../UVScope" as SubViewport


func _ready() -> void:
	if visible:
		texture = uv_scope.get_texture()
	else:
		set_process(false)


func _process(_delta: float) -> void:
	var image := texture.get_image()
	var center := image.get_size() / 2
	print("UV Color ", image.get_pixel(center.x, center.y))
