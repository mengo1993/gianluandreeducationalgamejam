extends Node2D
const MAX_PARTICLES : int = 100
const MAX_LIFETIME : int = 5

func _on_slider_amount_value_changed(value: float) -> void:
	$particles.amount = clamp(int(value), 1, MAX_PARTICLES)


func _on_slider_lifetime_value_changed(value: float) -> void:
	$particles.lifetime = clamp(int(value), 0.5, MAX_LIFETIME)
