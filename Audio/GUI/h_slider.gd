extends HSlider

@export var bus_name: String 

func _ready():
	var bus_index = AudioServer.get_bus_index(bus_name)
	
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value):
	var bus_index = AudioServer.get_bus_index(bus_name)

	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_value))

func _on_hover():
	SoundManager.play_sound(preload("res://Audio/GUI/Hover.ogg"))

func _on_click():
	SoundManager.play_sound(preload("res://Audio/GUI/Click.ogg"))
