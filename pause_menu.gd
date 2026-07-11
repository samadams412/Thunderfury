extends CanvasLayer

@onready var menu_container = $Control # The node holding the buttons
@onready var confirm_dialog = $ConfirmationDialog
#@onready var resume_button = $Control/Resume
func _ready():
	menu_container.visible = false

func _input(event):
	# Toggle pause with the "ui_cancel" (Esc key)
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	# Toggle pause status
	get_tree().paused = !get_tree().paused
	menu_container.visible = get_tree().paused
	if get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_resume_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	menu_container.visible = false


func _on_quit_to_menu_pressed() -> void:
	confirm_dialog.show()
	
func _on_confirmation_dialog_confirmed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
