extends Label


@onready var clear_subtitle_timer: Timer = $Timer

const PAUSE_SECONDS = 4
const CHARACTERS_PER_SECOND = 25.0

var SPEAKER_COLORS = {
	"p226": Color.LIGHT_SKY_BLUE,  # young male
	"p227": Color.DARK_VIOLET,  # female
	"p229": Color.DARK_GOLDENROD,  # male
	"p230": Color.GRAY,  # male
	"p240": Color.INDIAN_RED,  # female
	"p241": Color.LIGHT_SEA_GREEN,  # male
	"p245": Color.AQUAMARINE,  # female
	"p248": Color.DEEP_PINK,  # young female
	"p250": Color.DARK_MAGENTA,  # female
	"p256": Color.DODGER_BLUE,  # male
	"p267": Color.DEEP_SKY_BLUE,  # male deep voice
	"p270": Color.MEDIUM_PURPLE,  # young female
	"p273": Color.GHOST_WHITE,  # female
	"p285": Color.LIGHT_STEEL_BLUE,  # male
	"p287": Color.OLIVE_DRAB,  # male deep voice
	"p306": Color.LIGHT_SALMON,  # female
	"p317": Color.DARK_CYAN,  # male
	"p335": Color.HOT_PINK,  # young female
	"p336": Color.LIME,  # female
	"p347": Color.CORAL,  # adult female
}


func _ready():
	text = ""
	Signals.talk.connect(display_subtitle)
	clear_subtitle_timer.timeout.connect(clear_subtitle)


func display_subtitle(speaker_name: String, subtitle_text: String):
	text = subtitle_text
	label_settings.font_color = SPEAKER_COLORS.get(speaker_name, Color.WHITE)
	clear_subtitle_timer.start(PAUSE_SECONDS + len(subtitle_text) / CHARACTERS_PER_SECOND)


func clear_subtitle():
	text = ""
