extends Node2D
@onready var audio_main: AudioStreamPlayer2D = $Audio_Main

const MAX_PARTICLES : int = 100
const MAX_LIFETIME : int = 5
# cambiare tra particles e particles2 per avere due effetti differenti 
func _on_slider_amount_value_changed(value: float) -> void:
	$particles.amount = clamp(int(value), 1, MAX_PARTICLES)
	get_node("Control/particles3").amount = clamp(int(value), 1, MAX_PARTICLES)

func _on_slider_lifetime_value_changed(value: float) -> void:
	$particles.lifetime = clamp(int(value), 0.5, MAX_LIFETIME)
	get_node("Control/particles3").lifetime = clamp(int(value), 0.5, MAX_LIFETIME)

func _ready() -> void:
	audio_main.playing = true
	
