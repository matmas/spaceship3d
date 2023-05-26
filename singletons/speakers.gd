extends Node

enum Speaker {
	p226 = 226,
	p227 = 227,
	p229 = 229,
	p230 = 230,
	p240 = 240,
	p241 = 241,
	p245 = 245,
	p248 = 248,
	p250 = 250,
	p256 = 256,
	p267 = 267,
	p270 = 270,
	p273 = 273,
	p285 = 285,
	p287 = 287,
	p306 = 306,
	p317 = 317,
	p335 = 335,
	p336 = 336,
	p347 = 347,
}

var _SUBTITLE_COLORS = {
	Speaker.p226: Color.LIGHT_SKY_BLUE,  # young male
	Speaker.p227: Color.DARK_VIOLET,  # female
	Speaker.p229: Color.DARK_GOLDENROD,  # male
	Speaker.p230: Color.GRAY,  # male
	Speaker.p240: Color.INDIAN_RED,  # female
	Speaker.p241: Color.LIGHT_SEA_GREEN,  # male
	Speaker.p245: Color.AQUAMARINE,  # female
	Speaker.p248: Color.DEEP_PINK,  # young female
	Speaker.p250: Color.DARK_MAGENTA,  # female
	Speaker.p256: Color.DODGER_BLUE,  # male
	Speaker.p267: Color.DEEP_SKY_BLUE,  # male deep voice
	Speaker.p270: Color.MEDIUM_PURPLE,  # young female
	Speaker.p273: Color.GHOST_WHITE,  # female
	Speaker.p285: Color.LIGHT_STEEL_BLUE,  # male
	Speaker.p287: Color.OLIVE_DRAB,  # male deep voice
	Speaker.p306: Color.LIGHT_SALMON,  # female
	Speaker.p317: Color.DARK_CYAN,  # male
	Speaker.p335: Color.HOT_PINK,  # young female
	Speaker.p336: Color.LIME,  # female
	Speaker.p347: Color.CORAL,  # adult female
}


func get_subtitle_color(speaker: int) -> Color:
	return _SUBTITLE_COLORS.get(speaker, Color.WHITE)
