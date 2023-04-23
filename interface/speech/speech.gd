extends AudioStreamPlayer


func _ready() -> void:
	Signals.talk.connect(speak)


func speak(speaker_name: String, text: String) -> void:
	var speech := load("res://interface/speech/generated/%s_%s.ogg" % [speaker_name, text.validate_filename()]) as AudioStream
	if !playing:
		stream = speech
		play()
	else:
		var player := self.duplicate(DUPLICATE_USE_INSTANTIATION) as AudioStreamPlayer
		add_child(player)
		player.stream = speech
		player.play()
		await player.finished
		player.queue_free()
