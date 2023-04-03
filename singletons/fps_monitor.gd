extends Node

@onready var label = Label.new()


func _ready():
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_RIGHT)
	if OS.get_name() == "Android":
		label.label_settings = LabelSettings.new()
		label.label_settings.font_size = 30
		label.position.x = -50  # some phones have rounded corners
	add_child(label)


func _process(_delta):
	label.text = "{0} FPS".format([Engine.get_frames_per_second()])
