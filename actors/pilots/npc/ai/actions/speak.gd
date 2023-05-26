@tool
@icon("speak.svg")
class_name Speak
extends ActionLeaf

@onready var speech := $Speech as AudioStreamPlayer

@export var text_override: String
@export var speaker: Speakers.Speaker


func _ready() -> void:
	if speaker:
		var speaker_key := Speakers.Speaker.find_key(speaker) as String
		speech.stream = load("res://interface/speech/generated/%s_%s.ogg" % [speaker_key, _get_text().validate_filename()]) as AudioStream

		if Engine.is_editor_hint():
			var line := "%s:%s\n" % [speaker_key, _get_text()]
			var path := "res://interface/speech/phrases.txt"
			var file := FileAccess.open(path, FileAccess.READ)
			if file == null or not line in file.get_as_text(true):
				var file_access := FileAccess.READ_WRITE if FileAccess.file_exists(path) else FileAccess.WRITE_READ
				file = FileAccess.open(path, file_access)
				file.seek_end()
				file.store_string(line)


func before_run(_actor: Node, _blackboard: Blackboard) -> void:
	speech.play()
	Signals.talk.emit(speaker, _get_text())


func tick(_actor: Node, _blackboard: Blackboard) -> int:
	return RUNNING if speech.playing else SUCCESS


func _get_text() -> String:
	return text_override if text_override else String(name)
