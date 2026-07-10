extends Node2D

func _ready():
	# Hide the system cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Optional: Add a way to bring it back if the player pauses the game
func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
