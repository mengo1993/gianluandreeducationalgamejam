extends Control
const DURATION_OF_FADE : float = 0.3


func focus(texture : Texture2D, title : String, description : String) -> void:
	$TextureRect/VBoxContainer/HBoxContainer/TextureRect.texture = texture
	$TextureRect/VBoxContainer/HBoxContainer/RichTextLabel.text = title
	$TextureRect/VBoxContainer/RichTextLabel2.text = description
	
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, DURATION_OF_FADE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)


func fade_out() -> void:
	
	modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, DURATION_OF_FADE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
