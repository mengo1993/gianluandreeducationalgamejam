extends Control

var _is_mouse_over: bool = false
var _pending_focus_id: int = 0

const DURATION_OF_FADE : float = 0.4
const TIME_BETWEEN_SHOWING : float = 0.2

func focus(texture: Texture2D, title: String, description: String) -> void:
	# Start tracking a unique focus attempt
	_is_mouse_over = true
	_pending_focus_id += 1
	var this_focus_id = _pending_focus_id

	# Wait before showing
	await get_tree().create_timer(TIME_BETWEEN_SHOWING).timeout

	# Only proceed if mouse is still over and this is the latest focus call
	if not _is_mouse_over or this_focus_id != _pending_focus_id:
		return

	# Set content
	$TextureRect/VBoxContainer/HBoxContainer/TextureRect.texture = texture
	$TextureRect/VBoxContainer/HBoxContainer/RichTextLabel.text = title
	$TextureRect/VBoxContainer/RichTextLabel2.text = description

	# Fade in
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, DURATION_OF_FADE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)

func fade_out() -> void:
	_is_mouse_over = false

	modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, DURATION_OF_FADE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
