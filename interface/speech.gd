extends AudioStreamPlayer


func _ready() -> void:
	Signals.talk.connect(speak)


func speak(speaker_name: String, text: String) -> void:
	var speach := load("res://speech/generated/%s_%s.ogg" % [speaker_name, text.validate_filename()])
	if !playing:
		stream = speach
		play()
	else:
		var player = self.duplicate(DUPLICATE_USE_INSTANTIATION)
		add_child(player)
		player.stream = speach
		player.play()
		await player.finished
		player.queue_free()
