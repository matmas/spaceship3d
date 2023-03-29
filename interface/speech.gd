extends AudioStreamPlayer


func _ready():
	Signals.talk.connect(speak)


func speak(speaker_name: String, text: String):
	if !playing:
		stream = load("res://speech/generated/%s_%s.ogg" % [speaker_name, text.validate_filename()])
		play()

