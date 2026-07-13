extends Control

@onready var settings_menu = $SettingsMenu

func _ready():
	settings_menu.connect("closed", _on_settings_closed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://world.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_controls_button_pressed():
	$ButtonContainer.visible = false
	$ControlsMenu.visible = true
	
func _on_back_button_pressed():
	$ControlsMenu.visible = false
	$ButtonContainer.visible = true
	
func _on_settings_button_pressed():
	$ButtonContainer.hide()
	$SettingsMenu.show()

func _on_settings_closed():
	# This runs when SettingsMenu emits 'closed'
	$ButtonContainer.show()
