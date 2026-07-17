extends CanvasLayer

@onready var menu_container = $Control # The node holding the buttons
@onready var confirm_dialog = $ConfirmationDialog
@onready var settings_menu = $SettingsMenu
#@onready var resume_button = $Control/Resume
func _ready():
	menu_container.visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if settings_menu.visible:
			_close_settings()
		else:
			toggle_pause()

func toggle_pause():
	var world = get_tree().current_scene
	world.set_game_state(get_tree().paused)  # note: inverted, since paused is about to flip
	menu_container.visible = get_tree().paused

func _on_resume_pressed():
	get_tree().current_scene.set_game_state(true)
	menu_container.visible = false


func _on_quit_to_menu_pressed():
	confirm_dialog.show()
	
func _on_confirmation_dialog_confirmed():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func _on_confirmation_dialog_canceled():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _close_settings():
	settings_menu.hide()
	menu_container.show()

func _on_settings_pressed():
	menu_container.hide()
	settings_menu.show()


func _on_settings_menu_closed():
	_close_settings()
