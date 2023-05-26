extends Label

@onready var clear_subtitle_timer: Timer = $Timer

const PAUSE_SECONDS = 4
const CHARACTERS_PER_SECOND = 25.0


func _ready() -> void:
	text = ""
	Signals.talk.connect(display_subtitle)
	clear_subtitle_timer.timeout.connect(clear_subtitle)


func display_subtitle(speaker: int, subtitle_text: String) -> void:
	text = subtitle_text
	label_settings.font_color = Speakers.get_subtitle_color(speaker)
	clear_subtitle_timer.start(PAUSE_SECONDS + len(subtitle_text) / CHARACTERS_PER_SECOND)


func clear_subtitle() -> void:
	text = ""
