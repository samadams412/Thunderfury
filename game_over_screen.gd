extends CanvasLayer

@onready var return_button: Button = $Control/Return

#func _ready() -> void:
	#return_button.pressed.connect(_on_return_pressed)

func _on_return_pressed() -> void:
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://Menus/main_menu.tscn")
