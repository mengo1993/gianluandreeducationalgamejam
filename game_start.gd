extends Control
@onready var audio_intro: AudioStreamPlayer2D = $Audio_intro


func _on_button_pressed() -> void:
	get_tree().quit()


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _ready() -> void:
	audio_intro.finished.connect(func():
		
		audio_intro.play())
