extends Control


signal closed





func _on_hover():
	SoundManager.play_sound(preload("res://Audio/GUI/Hover.ogg"))

func _on_click():
	SoundManager.play_sound(preload("res://Audio/GUI/Click.ogg"))


func _on_back_button_pressed() -> void:
	hide()
	closed.emit()




func _on_master_volume_slider_value_changed(_value: float) -> void:
	SoundManager.play_sound(preload("res://Audio/GUI/Click.ogg"))


func _on_music_volume_slider_value_changed(_value: float) -> void:
	SoundManager.play_sound(preload("res://Audio/GUI/Click.ogg"))


func _on_sfx_volume_slider_value_changed(_value: float) -> void:
	SoundManager.play_sound(preload("res://Audio/GUI/Click.ogg"))
