extends TextureProgressBar

@onready var recent_damage_bar := $RecentDamageBar as TextureProgressBar

var target_value := value
var current_value := value
var speed := 0.0


func _ready() -> void:
	value_changed.connect(_value_changed)


func _process(delta: float) -> void:
	if target_value != current_value:
		speed += delta * 50.0
	else:
		speed = 0.0
	current_value = move_toward(current_value, target_value, speed * delta)
	recent_damage_bar.value = current_value


func _value_changed(new_value: float):
	target_value = new_value
