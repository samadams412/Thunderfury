extends Control


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://world.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_controls_button_pressed():
	$VBoxContainer.visible = false
	$ControlsMenu.visible = true
	
func _on_back_button_pressed():
	$ControlsMenu.visible = false
	$VBoxContainer.visible = true
	
