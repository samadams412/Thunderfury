extends Node2D

func _ready():
	# Hide the system cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func set_game_state(is_playing: bool):
	if is_playing:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		get_tree().paused = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true

func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		if not get_tree().paused:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
